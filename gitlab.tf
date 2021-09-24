resource "gitlab_project" "oconnorninja-pages" {
  name               = "oconnor.ninja"
  description        = "Serves as the static site to serve the server delegation via well-known files for server and client for Matrix"
  visibility_level   = "public"
  pages_access_level = "public"
}

resource "gitlab_branch_protection" "BranchProtect" {
  project            = gitlab_project.oconnorninja-pages.id
  branch             = "main"
  push_access_level  = "developer"
  merge_access_level = "developer"
}
