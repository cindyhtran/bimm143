# Create Personal Access Token
install.packages("usethis")
library(usethis)
create_github_token()

# Store Personal Access Token to Connect RStudio and GitHub
install.packages("gitcreds")
library(gitcreds)
gitcreds_set()