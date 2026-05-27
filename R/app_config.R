# Helper to resolve paths within the installed package
app_sys <- function(...) {
  system.file(..., package = "cyclestatsv2")
}
