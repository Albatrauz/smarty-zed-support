use std::{env, fs};
use zed_extension_api::{self as zed, LanguageServerId, Result};

/// NPM package that ships the Smarty language server (extracted from the
/// `ssigwart/vscode-smarty` extension). Provides completions for Smarty tags,
/// modifiers and in-file variables, `{include}` path navigation and XSS
/// diagnostics. It runs on Node and does not require a PHP installation.
const PACKAGE_NAME: &str = "vscode-smarty-langserver-extracted";

/// Name of the binary the package exposes (used to detect a global install).
const BIN_NAME: &str = "smarty-language-server";

/// Entry point of the server, relative to the extension's working directory
/// once the NPM package has been installed there.
const SERVER_PATH: &str =
    "node_modules/vscode-smarty-langserver-extracted/dist/smarty-language-server/html-language-features/smarty/server.js";

struct SmartyExtension {
    /// Set once we know the server is installed, so we don't hit the network
    /// on every `language_server_command` call.
    did_find_server: bool,
}

impl SmartyExtension {
    fn server_exists(&self) -> bool {
        fs::metadata(SERVER_PATH).is_ok_and(|stat| stat.is_file())
    }

    /// Ensures the npm-based server is available, returning the command Zed
    /// should run. Prefers a globally installed `smarty-language-server` if the
    /// user already has one on their PATH.
    fn language_server_command(
        &mut self,
        language_server_id: &LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<zed::Command> {
        // 1. Use a global install if present — no download required.
        if let Some(path) = worktree.which(BIN_NAME) {
            return Ok(zed::Command {
                command: path,
                args: vec!["--stdio".to_string()],
                env: Default::default(),
            });
        }

        // 2. Otherwise install/update the npm package into the extension dir
        //    and run it through Zed's bundled Node.
        let node = zed::node_binary_path()?;
        self.install_server_if_needed(language_server_id)?;

        let server_path = env::current_dir()
            .map_err(|e| format!("failed to resolve extension directory: {e}"))?
            .join(SERVER_PATH)
            .to_string_lossy()
            .to_string();

        Ok(zed::Command {
            command: node,
            args: vec![server_path, "--stdio".to_string()],
            env: Default::default(),
        })
    }

    fn install_server_if_needed(&mut self, language_server_id: &LanguageServerId) -> Result<()> {
        let installed_version = zed::npm_package_installed_version(PACKAGE_NAME)?;

        // Already installed and verified this session: nothing to do.
        if self.did_find_server && installed_version.is_some() {
            return Ok(());
        }

        zed::set_language_server_installation_status(
            language_server_id,
            &zed::LanguageServerInstallationStatus::CheckingForUpdate,
        );

        // Resolving the latest version requires the network. If it fails but we
        // already have a working install, keep using it (offline friendly).
        let latest_version = match zed::npm_package_latest_version(PACKAGE_NAME) {
            Ok(version) => version,
            Err(err) => {
                if installed_version.is_some() && self.server_exists() {
                    zed::set_language_server_installation_status(
                        language_server_id,
                        &zed::LanguageServerInstallationStatus::None,
                    );
                    self.did_find_server = true;
                    return Ok(());
                }
                return Err(format!(
                    "could not determine latest version of {PACKAGE_NAME}: {err}"
                ));
            }
        };

        let needs_install =
            installed_version.as_deref() != Some(latest_version.as_str()) || !self.server_exists();

        if needs_install {
            zed::set_language_server_installation_status(
                language_server_id,
                &zed::LanguageServerInstallationStatus::Downloading,
            );

            zed::npm_install_package(PACKAGE_NAME, &latest_version).map_err(|err| {
                zed::set_language_server_installation_status(
                    language_server_id,
                    &zed::LanguageServerInstallationStatus::Failed(err.clone()),
                );
                format!("failed to install {PACKAGE_NAME}@{latest_version}: {err}")
            })?;

            if !self.server_exists() {
                let message = format!(
                    "installed {PACKAGE_NAME}@{latest_version}, but {SERVER_PATH} was not found"
                );
                zed::set_language_server_installation_status(
                    language_server_id,
                    &zed::LanguageServerInstallationStatus::Failed(message.clone()),
                );
                return Err(message);
            }
        }

        zed::set_language_server_installation_status(
            language_server_id,
            &zed::LanguageServerInstallationStatus::None,
        );
        self.did_find_server = true;
        Ok(())
    }
}

impl zed::Extension for SmartyExtension {
    fn new() -> Self {
        Self {
            did_find_server: false,
        }
    }

    fn language_server_command(
        &mut self,
        language_server_id: &LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<zed::Command> {
        self.language_server_command(language_server_id, worktree)
    }
}

zed::register_extension!(SmartyExtension);
