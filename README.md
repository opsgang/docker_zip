# Zip-only Docker image

Statically compiled zip as a Docker image "FROM scratch", leaner than venison.

## Problem Statement

Often all you need is to zip up something. For example, an AWS
Lambda function. In private environments, private registered can
be all tangled up if you want to zip and upload or deploy in the
same step.

Here comes a public image, which provides a statically compiled "zip" and friends **in
🥁 640k**. Sounds like a Microsoft wet dream in the '80s.

## Available Tools

The Docker image contains only the following binaries:

- zip
- zipcloak
- zipnote
- zipsplit


## Usage

```
docker run --rm -it -v $(pwd):/workspace:z -w /workspace opsgang/zip -r9 function.zip
```

## Testing

Built from Alpine and completely distroless. Use it with confidence.
If you know a CVE scanner which eats distroless images, [please let us know](https://github.com/opsgang/docker_zip/issues).

## Links

* [opsgang/zip on Docker Hub](https://hub.docker.com/r/opsgang/zip)
* [Dockerfile](https://github.com/opsgang/docker_zip/blob/main/Dockerfile)
* [Build pipeline](https://github.com/opsgang/docker_zip/tree/main/.github/workflows)
