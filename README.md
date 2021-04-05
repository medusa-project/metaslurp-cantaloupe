Docker container hosting a Cantaloupe instance for the
[Digital Collections Gateway](https://metadata.library.illinois.edu/).

# Instance Overview

* Cantaloupe listens on HTTP port 8182.
* AWS credentials are obtained from a task IAM role. When running locally,
  these are obtained from an [ECS Local Endpoint](https://aws.amazon.com/blogs/compute/a-guide-to-locally-testing-containers-with-amazon-ecs-local-endpoints-and-docker-compose/).
* Identifiers vary depending on the content service. The identifier prefix
  (`dls-*`, `idnc-*`, etc.) is used by the `source()` delegate method to
  determine what Source to use to find a particular image:
    * S3Source is used for DLS.
    * HttpSource is used for IDNC.
    * These sources' delegate methods then look up the "master access image"
      URI by fetching the item's JSON representation from metaslurp.
* The derivative cache is S3Cache.
* Format assignments:
    * JPEG: TurboJpegProcessor
    * JPEG2000: KakaduNativeProcessor
    * PDF: PdfBoxProcessor
    * Everything else: Java2dProcessor

# Build

1. Look at the comment header of `image_files/cantaloupe.properties` to see
   what version it's for.
2. Download that version's
   [release zip file](https://github.com/medusa-project/cantaloupe/releases)
   into `image_files`.
    * You can probably use any newer version, as long as the config file
      contains the right keys for it, and any dependencies are in place.
    * This could be automated, but doing it this way makes it easier to use
      arbitrary snapshots.
3. Copy `env-*.list.sample` to `env-*.list` and fill them in. **Don't commit
   any to version control!**
4. `./docker-build.sh`

# Run

## Locally

1. `aws login` ([GitHub](https://github.com/techservicesillinois/awscli-login))
2. `docker-compose up --build`

## In ECS

In ECS, the `*.list` files aren't used, so all of the variables in its
"Container Runtime Environment Variables" section have to be set in the task
definition.

1. `./ecr-push.sh`
2. `./ecs-deploy.sh`

# ECS Configuration Notes

Images are tagged with the Cantaloupe version. There is also a `latest` tag
applied to the latest version which is what is specified in the task
definition. If there is ever a need to revert to a previous version, the
task definition must be updated (in Terraform) to specify that version.
