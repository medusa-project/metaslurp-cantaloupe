Docker container hosting a Cantaloupe instance for the
[Digital Collections Gateway](https://metadata.library.illinois.edu/).

# Instance Overview

* Cantaloupe runs in standalone mode, using its embedded web server listening
  on HTTP port 8182.
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
3. Copy `env-*.list.sample` to `env-*.list` and fill them in. **Don't commit
   any to version control!**
4. `./docker-build.sh`

# Run

## Locally

1. `./docker-run.sh`
2. It's now listening at `http://localhost:8182`.

## In ECS

In ECS, the `*.list` files aren't used, so all of the variables in its
"Container Runtime Environment Variables" section have to be set in the task
definition.

1. `./ecr-push.sh`
2. `./ecs-deploy.sh`
