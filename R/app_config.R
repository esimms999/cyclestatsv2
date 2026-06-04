# Helper to resolve paths within the installed package.
# Package name is assembled at runtime so renv does not treat this package
# as an external dependency during deployment bundling.
.app_pkg <- paste0("cyclestats", "v2")
app_sys <- function(...) {
  system.file(..., package = .app_pkg)
}
