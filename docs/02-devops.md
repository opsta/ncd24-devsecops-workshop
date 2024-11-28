# DevOps Workshop

## Walkthought environment

* Run `kubectl --namespace argocd get secrets argocd-initial-admin-secret --template={{.data.password}} | base64 --decode` command and copy ArgoCD admin password
* Click on icon `Web preview` on the top right of Cloud Shell. Click on `Change port` and put port number `31001` to access to ArgoCD
* Login with user `admin` and password from above command
* You will see 2 application with dev and prd environments running but it won't run. Try to check for status and error.
* Go to `https://github.com/[GITHUBUSER]?tab=repositories` to see `ncd24-gitops` and `ncd24-fastapi` repositories
* `ncd24-fastapi` repository is where your application code and CI/CD here
* `ncd24-gitops` repository is GitOps repository for ArgoCD

## Check CI/CD on GitHub Actions

* Go to `https://github.com/[GITHUBUSER]/ncd24-fastapi/actions` or go to your `ncd24-fastapi` repository and click on `Actions` tab
* You will see workflow `feat: first initial` is automatically run when first pushing the code and it should finished now.
  * Click on workflow to see workflow jobs
  * `setup` job is for prepare and setup environment variables
  * `build-push` job is to build container image and push to GitHub container registry. You can see your container image here `https://github.com/[GITHUBUSER]/ncd24-fastapi/pkgs/container/ncd24-fastapi` or go to `https://github.com/[GITHUBUSER]` first and click on `Packages` tab then `ncd24-fastapi` package
  * `git-commit` job is to update and commit newly build container image into `helm-values/ncd24-fastapi-dev.yaml` in `ncd24-gitops` repository
* Go check `ncd24-gitops` repository. And go check `helm-values/ncd24-fastapi-dev.yaml` file to see tag is changing
* Go back to ArgoCD again to see the status of the application in dev environment. It should healthy now.
  * Put `curl http://localhost:31002` in Cloud Shell to see return output from fastapi application
  * You can try `curl http://localhost:31002/health` and `curl http://localhost:31002/chain` to test other fastapi endpoint

## Production deployment

### Tagging version

* Go to `https://github.com/[GITHUBUSER]/ncd24-fastapi/actions` or go to your `ncd24-fastapi` repository and click on `Actions` tab
* Click on `2. Production tagging` workflow
* Click on `Run workflow` button on the right and click `Run workflow`
* GitHub Actions will run tagging workflow that has only `tag-and-release` job
  * `tag-and-release` job is going to copy and tag container image first. You can see tag in `https://github.com/[GITHUBUSER]/ncd24-fastapi/pkgs/container/ncd24-fastapi` or click on `Packages` on the main repository page
  * `tag-and-release` job then is going to create release. You can see from `https://github.com/[GITHUBUSER]/ncd24-fastapi/releases` or click on `Releases` on the main repository page

### Deploy on production

* Go to `https://github.com/[GITHUBUSER]/ncd24-fastapi/actions` or go to your `ncd24-fastapi` repository and click on `Actions` tab
* Click on `3. Production deployment` workflow
* Click on `Run workflow` button on the right
  * `Automatically pick the latest tag version`: checked
  * Click `Run workflow`
* GitHub Actions will run the following jobs
  * `setup` job is for prepare and setup environment variables
  * `git-commit` job is to update and commit newly build container image into `helm-values/ncd24-fastapi-prd.yaml` in `ncd24-gitops` repository
* Go check `ncd24-gitops` repository. And go check `helm-values/ncd24-fastapi-prd.yaml` file to see tag is changing
* Go back to ArgoCD again to see the status of the application in dev environment. It should healthy now.
* If it is not healthy, you can try click on `REFRESH` then `SYNC` button to enforce sync.
  * Put `curl http://localhost:31003` in Cloud Shell to see return output from fastapi application
  * You can try `curl http://localhost:31003/health` and `curl http://localhost:31003/chain` to test other fastapi endpoint

## Update source code

### Change hello world message

* Edit `~/ncd24-fastapi/main.py` on `@app.get("/")` path
  * Change `return {"Hello": "World"}` to `return {"Hello": "World!"}`

### Commit with Git GUI Editor

* Click on `Source Control` icon on the left of Cloud Shell Editor
* You will see many git repositories
* Go to `Source Control` and click on `+` icon next to your `ncd24-fastapi` git repository. You will see the file will move to `Changes` to `Staged Changes`
  * It will be the same as `git add` command
* Put the commit message in `ncd24-fastapi` git repository and click on `Commit` or `ctrl+enter` on Windows or `command+enter` on MacOS
  * It will be the same as `git commit` command
* Click on `...` icon next to `ncd24-fastapi` git repository and click on `Push`
  * It will be the same as `git push` command

### Check deployment status and deploy to production

* Go to `https://github.com/[GITHUBUSER]/ncd24-fastapi/actions` or go to your `ncd24-fastapi` repository and click on `Actions` tab
* You will see new workflow from your committed
  * Click on workflow to see workflow jobs
* Go check `ncd24-gitops` repository. And go check `helm-values/ncd24-fastapi-dev.yaml` file to see tag is changing again
* Go back to ArgoCD again to see the status of the application in dev environment. If it is not update, you can try click on `REFRESH` then `SYNC` button to enforce sync.
  * Put `curl http://localhost:31002` in Cloud Shell to see your new return output from fastapi application
* Try to deploy to production

## Navigation

* Previous: [Preparation](01-prepare.md)
* [Home](../README.md)
* Next: [DevSecOps Workshop](03-devsecops.md)
