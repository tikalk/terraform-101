# Core modules

## Create Github code-repos

* Takes care of setting up your project repositories.

### Step 1 - create a Github Team in our Given Github Orginization

**Plan** create the "Infrastructure Team" group:

1. set your `TF_VAR_github_token` environment variable to a token you created in your githu account as described [here](https://help.github.com/en/articles/creating-a-personal-access-token-for-the-command-line)

2. set any other variables in a `terraform.tfvars` file if needed.
    as an exmaple you can set your orginzation as a default value to the `github_organization` variable
    e.g:

    ```sh
    variable "github_organization" {
        type    = "string"
        default = "tikal-workshops"
        }
    ```

    or set the `TF_VAR_github_organization` to  `tikal-workshops` - this is basic terraform behaviour ...

* Initilize the plan <details><summary>`terrform init`</summary>

    <p>

    ```sh
    terraform init
    Initializing modules...
    - module.infra-team
    - module.infra-helm-repository
    - module.infra-terraform-repository

    Initializing provider plugins...

    The following providers do not have any version constraints in configuration,
    so the latest version was installed.

    To prevent automatic upgrades to new major versions that may contain breaking
    changes, it is recommended to add version = "..." constraints to the
    corresponding provider blocks in configuration, with the constraint strings
    suggested below.

    * provider.github: version = "~> 2.1"

    Terraform has been successfully initialized!

    You may now begin working with Terraform. Try running "terraform plan" to see
    any changes that are required for your infrastructure. All Terraform commands
    should now work.

    If you ever set or change modules or backend configuration for Terraform,
    rerun this command to reinitialize your working directory. If you forget, other
    commands will detect it and remind you to do so if necessary.
    ```

    </p>
* Create the infra team<details><summary>`terraform plan -target=module.infra-team`</summary>
    <p>

    ```sh
    terraform plan -target=module.infra-team
    Refreshing Terraform state in-memory prior to plan...
    The refreshed state will be used to calculate this plan, but will not be
    persisted to local or remote state storage.


    ------------------------------------------------------------------------

    An execution plan has been generated and is shown below.
    Resource actions are indicated with the following symbols:
    + create

    Terraform will perform the following actions:

    + module.infra-team.github_team.team
        id:       <computed>
        etag:     <computed>
        name:     "Infrastructure Team"
        privacy:  "secret"
        slug:     <computed>

    + module.infra-team.github_team_membership.maintainer_members
        id:       <computed>
        etag:     <computed>
        role:     "maintainer"
        team_id:  "${github_team.team.id}"
        username: "hagzag"

    + module.infra-team.github_team_membership.members
        id:       <computed>
        etag:     <computed>
        role:     "member"
        team_id:  "${github_team.team.id}"
        username: "hagzag"


    Plan: 3 to add, 0 to change, 0 to destroy.

    ------------------------------------------------------------------------

    Note: You didn't specify an "-out" parameter to save this plan, so Terraform
    can't guarantee that exactly these actions will be performed if
    "terraform apply" is subsequently run.
    ```

    </p>

### Step 2 - Create repos

**Plan** create 2 Github repositories:

1. 1 Repository For our terraform code named `infra-terraform` (the repo we will probebly push this code to later on).

    ```sh
    module "infra-terraform-repository" {
    source             = "../modules/github/repository"
    name               = "infra-terraform"
    description        = "Terraform Infrastructure-as-a-Code"
    admin_access_teams = ["${module.infra-team.name}"]
    }
    ```

2. 1 Repository for our helm charts called ` (to be used later in this workshop)

    ```sh
    module "infra-helm-repository" {
        source             = "../modules/github/repository"
        name               = "infra-helm-charts"
        description        = "Helm Charts Repository"
        admin_access_teams = ["${module.infra-team.name}"]
    }
    ```

* Terraform plan<details><summary>`terraform plan`</summary>
    <p>

    ```sh
    terraform plan
    Refreshing Terraform state in-memory prior to plan...
    The refreshed state will be used to calculate this plan, but will not be
    persisted to local or remote state storage.

    github_team.team: Refreshing state... (ID: 3300339)
    github_team_membership.maintainer_members: Refreshing state... (ID: 3300339:hagzag)
    data.github_team.admin_access_teams: Refreshing state...
    data.github_team.admin_access_teams: Refreshing state...

    ------------------------------------------------------------------------

    An execution plan has been generated and is shown below.
    Resource actions are indicated with the following symbols:
    + create

    Terraform will perform the following actions:

    + module.infra-helm-repository.github_branch_protection.app_repository_protection
        id:                                                              <computed>
        branch:                                                          "master"
        enforce_admins:                                                  "true"
        etag:                                                            <computed>
        repository:                                                      "infra-helm-charts"
        required_pull_request_reviews.#:                                 "1"
        required_pull_request_reviews.0.dismiss_stale_reviews:           "true"
        required_pull_request_reviews.0.required_approving_review_count: "1"
        restrictions.#:                                                  "1"

    + module.infra-helm-repository.github_repository.app_repository
        id:                                                              <computed>
        allow_merge_commit:                                              "false"
        allow_rebase_merge:                                              "true"
        allow_squash_merge:                                              "true"
        archived:                                                        "false"
        auto_init:                                                       "true"
        default_branch:                                                  <computed>
        description:                                                     "Helm Charts Repository"
        etag:                                                            <computed>
        full_name:                                                       <computed>
        git_clone_url:                                                   <computed>
        html_url:                                                        <computed>
        http_clone_url:                                                  <computed>
        name:                                                            "infra-helm-charts"
        private:                                                         "false"
        ssh_clone_url:                                                   <computed>
        svn_url:                                                         <computed>

    + module.infra-helm-repository.github_team_repository.admin_access_teams
        id:                                                              <computed>
        etag:                                                            <computed>
        permission:                                                      "admin"
        repository:                                                      "infra-helm-charts"
        team_id:                                                         "3300339"

    + module.infra-terraform-repository.github_branch_protection.app_repository_protection
        id:                                                              <computed>
        branch:                                                          "master"
        enforce_admins:                                                  "true"
        etag:                                                            <computed>
        repository:                                                      "infra-terraform"
        required_pull_request_reviews.#:                                 "1"
        required_pull_request_reviews.0.dismiss_stale_reviews:           "true"
        required_pull_request_reviews.0.required_approving_review_count: "1"
        restrictions.#:                                                  "1"

    + module.infra-terraform-repository.github_repository.app_repository
        id:                                                              <computed>
        allow_merge_commit:                                              "false"
        allow_rebase_merge:                                              "true"
        allow_squash_merge:                                              "true"
        archived:                                                        "false"
        auto_init:                                                       "true"
        default_branch:                                                  <computed>
        description:                                                     "Terraform Infrastructure-as-a-Code"
        etag:                                                            <computed>
        full_name:                                                       <computed>
        git_clone_url:                                                   <computed>
        html_url:                                                        <computed>
        http_clone_url:                                                  <computed>
        name:                                                            "infra-terraform"
        private:                                                         "false"
        ssh_clone_url:                                                   <computed>
        svn_url:                                                         <computed>

    + module.infra-terraform-repository.github_team_repository.admin_access_teams
        id:                                                              <computed>
        etag:                                                            <computed>
        permission:                                                      "admin"
        repository:                                                      "infra-terraform"
        team_id:                                                         "3300339"


    Plan: 6 to add, 0 to change, 0 to destroy.

    ------------------------------------------------------------------------

    Note: You didn't specify an "-out" parameter to save this plan, so Terraform
    can't guarantee that exactly these actions will be performed if
    "terraform apply" is subsequently run.
    ```
</p>

* Terraform apply<details><summary>`terraform apply`</summary>
    <p>
    
    ```sh
    terraform apply
    github_team.team: Refreshing state... (ID: 3300339)
    github_team_membership.maintainer_members: Refreshing state... (ID: 3300339:hagzag)
    data.github_team.admin_access_teams: Refreshing state...
    data.github_team.admin_access_teams: Refreshing state...

    An execution plan has been generated and is shown below.
    Resource actions are indicated with the following symbols:
    + create

    Terraform will perform the following actions:

    + module.infra-helm-repository.github_branch_protection.app_repository_protection
        id:                                                              <computed>
        branch:                                                          "master"
        enforce_admins:                                                  "true"
        etag:                                                            <computed>
        repository:                                                      "infra-helm-charts"
        required_pull_request_reviews.#:                                 "1"
        required_pull_request_reviews.0.dismiss_stale_reviews:           "true"
        required_pull_request_reviews.0.required_approving_review_count: "1"
        restrictions.#:                                                  "1"

    + module.infra-helm-repository.github_repository.app_repository
        id:                                                              <computed>
        allow_merge_commit:                                              "false"
        allow_rebase_merge:                                              "true"
        allow_squash_merge:                                              "true"
        archived:                                                        "false"
        auto_init:                                                       "true"
        default_branch:                                                  <computed>
        description:                                                     "Helm Charts Repository"
        etag:                                                            <computed>
        full_name:                                                       <computed>
        git_clone_url:                                                   <computed>
        html_url:                                                        <computed>
        http_clone_url:                                                  <computed>
        name:                                                            "infra-helm-charts"
        private:                                                         "false"
        ssh_clone_url:                                                   <computed>
        svn_url:                                                         <computed>

    + module.infra-helm-repository.github_team_repository.admin_access_teams
        id:                                                              <computed>
        etag:                                                            <computed>
        permission:                                                      "admin"
        repository:                                                      "infra-helm-charts"
        team_id:                                                         "3300339"

    + module.infra-terraform-repository.github_branch_protection.app_repository_protection
        id:                                                              <computed>
        branch:                                                          "master"
        enforce_admins:                                                  "true"
        etag:                                                            <computed>
        repository:                                                      "infra-terraform"
        required_pull_request_reviews.#:                                 "1"
        required_pull_request_reviews.0.dismiss_stale_reviews:           "true"
        required_pull_request_reviews.0.required_approving_review_count: "1"
        restrictions.#:                                                  "1"

    + module.infra-terraform-repository.github_repository.app_repository
        id:                                                              <computed>
        allow_merge_commit:                                              "false"
        allow_rebase_merge:                                              "true"
        allow_squash_merge:                                              "true"
        archived:                                                        "false"
        auto_init:                                                       "true"
        default_branch:                                                  <computed>
        description:                                                     "Terraform Infrastructure-as-a-Code"
        etag:                                                            <computed>
        full_name:                                                       <computed>
        git_clone_url:                                                   <computed>
        html_url:                                                        <computed>
        http_clone_url:                                                  <computed>
        name:                                                            "infra-terraform"
        private:                                                         "false"
        ssh_clone_url:                                                   <computed>
        svn_url:                                                         <computed>

    + module.infra-terraform-repository.github_team_repository.admin_access_teams
        id:                                                              <computed>
        etag:                                                            <computed>
        permission:                                                      "admin"
        repository:                                                      "infra-terraform"
        team_id:                                                         "3300339"


    Plan: 6 to add, 0 to change, 0 to destroy.

    Do you want to perform these actions?
    Terraform will perform the actions described above.
    Only 'yes' will be accepted to approve.

    Enter a value:
    ```
    </p>
