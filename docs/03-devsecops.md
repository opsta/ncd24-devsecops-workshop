# DevSecOps Workshop

## Add Trivy SCA scan to GitHub Actions

* Append the following to `~/ncd24-fastapi/.github/workflows/nonprd.yaml` file

```yaml
  trivy-sca-security-gate:
    runs-on: ubuntu-latest
    needs:
      - setup
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      - name: Trivy SCA Vulnerability Fail Gate
        uses: aquasecurity/trivy-action@0.28.0
        with:
          scan-type: "fs"
          scan-ref: .
          scanners: 'vuln,license'
          severity: 'MEDIUM,HIGH,CRITICAL'
          format: table
          output: ${{ env.TRIVY_SCA_OUTPUT_FILENAME }}
          exit-code: 1
        env:
          TRIVY_DISABLE_VEX_NOTICE: true
      - name: Publish Trivy SCA Output to Summary
        if: always()
        run: |
          if [[ -s $TRIVY_SCA_OUTPUT_FILENAME ]]; then
            {
              echo "### Trivy SCA Output"
              echo "<details><summary>Click to expand</summary>"
              echo ""
              echo '```terraform'
              cat $TRIVY_SCA_OUTPUT_FILENAME
              echo '```'
              echo "</details>"
            } >> $GITHUB_STEP_SUMMARY
          fi
    env:
      TRIVY_SCA_OUTPUT_FILENAME: trivy-sca-report.txt

  trivy-image-security-gate:
    runs-on: ubuntu-latest
    needs:
      - setup
      - build-push
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      - name: Trivy Image Vulnerability Fail Gate
        uses: aquasecurity/trivy-action@0.28.0
        with:
          image-ref: ${{ env.IMAGE_NAME }}:${{ needs.setup.outputs.image_tag }}
          scanners: 'vuln,misconfig,secret'
          severity: 'HIGH,CRITICAL'
          format: table
          ignore-unfixed: true
          output: ${{ env.TRIVY_IMAGE_OUTPUT_FILENAME }}
          exit-code: 1
        env:
          TRIVY_DISABLE_VEX_NOTICE: true
      - name: Publish Trivy Image Output to Summary
        if: always()
        run: |
          if [[ -s $TRIVY_IMAGE_OUTPUT_FILENAME ]]; then
            {
              echo "### Trivy Image Output"
              echo "<details><summary>Click to expand</summary>"
              echo ""
              echo '```terraform'
              cat $TRIVY_IMAGE_OUTPUT_FILENAME
              echo '```'
              echo "</details>"
            } >> $GITHUB_STEP_SUMMARY
          fi
    env:
      TRIVY_IMAGE_OUTPUT_FILENAME: trivy-image-report.txt
```

* Commit and push to GitHub
* Go to GitHub Actions to see the workflow. You will see the following jobs
  * `trivy-sca-security-gate` this will try to detect and scan dependencies file. In this case it will scan `requirements.txt`
  * `trivy-image-security-gate` this will scan container image
* You will find it won't pass security gate. Check the output to see in output summary on workflow page to see the scan result.

## Fix vulnerability

* Update `~/ncd24-fastapi/requirements.txt` from `requests==2.28.2` to `requests==2.32.3`
* Update `~/ncd24-fastapi/Dockerfile` from `FROM python:3.11.3-alpine3.18` to `FROM python:3.13.0-alpine3.20`
* Commit and push to GitHub
* Go to GitHub Actions to see the workflow again to see if everything is green.

## Navigation

* Previous: [DevOps Workshop](02-devops.md)
* [Home](../README.md)
