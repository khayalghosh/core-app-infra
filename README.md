# vCluster Platform

## Development

If all you care is quickly spinning up a working Loft environment, open the repo
in DevPod.

[![Open in DevPod!](https://devpod.sh/assets/open-in-devpod.svg)](https://devpod.sh/open#https://github.com/loft-sh/loft-enterprise)

### Dependencies

- [Just]
- [devspace]
- [mkcert]

#### Just

Within Loft, we employ [Just] as a command runner with project-specific commands.

Within the [Justfile](./Justfile) commands, called recipes, are stored with a
make-inspired syntax.

These commands can be invoked from any working directory using
`just [cmd name] [optional arguments]`, specific receipt names and necessary
arguments will be shown in the console output.

For a list of receipts, run `just`.

### Local Setup with `just`

First, create local dev Kind k8s clusters using:

```bash
just create-kind
```

Then, activate `devspace` namespace using

```bash
devspace use namespace loft
```

And start development environment with:

```bash
just dev-loft
```

After everything starts up and you see application logs, open another terminal
and run:

```bash
just dev-ui
```

This will start frontend development server with `vcluster-platform` UI. Go to
<https://localhost:8080/> and use username `admin` and password `test123` to
access it!

#### Windows Troubleshooting

It's important that you clone the repository with the git option `core.autocrlf` set to `false`, as otherwise, bash scripts such as the `devspace_start.sh` script will break. 

```bash
git config --global core.autocrlf false
```

### Local Setup (automated with zellij)

#### Additional dependencies

- [zellij]
- [k9s]

One can create the necessary local Kind Kubernetes cluster using:

```bash
just create-kind
```

Running Loft can be performed using:

```bash
just dev
```

Stopping the Kind managed cluster can be done using:

```bash
just delete-kind
```

### Local Setup (manual)

1. Start loft in a different terminal with either:
    - `devspace run dev --start`
    - or `devspace run dev`. Wait until the terminal shows up and enter:
   `go run -mod vendor cmd/loft/main.go`
2. Install UI dependencies with `cd ui && yarn`. Then start the ui with `yarn start`.
3. Accept any untrusted certificates (e.g. for Chrome via
 `chrome://flags/#allow-insecure-localhost`, click 'relaunch Chrome' for the
 settings to take effect)
4. Navigate to <https://localhost:8080> and login to your development instance.

### Login credentials

For local development, the default credentials are `username: admin`,
`password: test123`.

### Debugging

The `.vscode/launch.json` file contains debugging configurations for loft,
loft-agent and e2e tests.
E2E tests can be started in debug mode simply by running the `Launch e2e tests`
configuration in VSCode.

If you wish to run the agent in debug mode with delve:

1. Start the loft-agent in debug mode with either:
    - Run `devspace run dev-agent --debug`
    - or run `devspace run dev-agent` and wait until the terminal shows up -->
  then run `dlv debug ./cmd/agent --listen=0.0.0.0:2345 --api-version=2 --output
 /tmp/__debug_bin --headless --build-flags="-mod=vendor"`.
2. Wait until the `API server listening at: [::]:2345` message appears
3. Start the "Debug agent: ..." configuration in VSCode to connect your debugger
 session.

   **Note:** Agent won't be running until you connect with the debugger.

   **Note:** Agent will be stopped once you detach your debugger session.

If you wish to run the loft in debug mode with delve:

1. Run loft in debug mode with either:
    - run `devspace run dev --debug`
    - or run `devspace run dev` and wait until the terminal shows up, then run
   `dlv debug ./cmd/loft --listen=0.0.0.0:2345 --api-version=2 --output /tmp/__debug_bin
 --headless --build-flags="-mod=vendor"`
2. Wait until the `API server listening at: [::]:2345` message appears
3. For Visual Studio code: Start the "Debug loft: ..." configuration in VSCode
  to connect your debugger session.

   For Goland: Create a "Go Remote" config with `host` set to `localhost` and
   `port` set to `23450`.

   **Note:** Loft won't be running until you connect with the debugger.

   **Note:** Loft will be stopped once you detach your debugger session.

## Persist Build Cache and Synced dirs (for faster local development)

The go build cache is persisted to the persistent volumes claims `loft-devspace`
and `loft-devspace-agent`. To keep the build cache across clusters, you can restore
these PVCs to the state from the prior cluster where the build was cached.

Example for kind (do before running devspace):

Save this perist-pvs.yaml. Optionally, replace `/kind-shared-storage-hostpath`
with any other path to set the storage directory in all of the steps below.

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
    - role: control-plane
      # add a mount from /path/to/my/files on the host to /files on the node
      extraMounts:
          - hostPath: /kind-shared-storage-hostpath
            containerPath: /var/local-path-provisioner
```

Ensure the directories exist:

```bash
sudo mkdir -p /kind-shared-storage-hostpath/loft-devspace /kind-shared-storage-hostpath/loft-agent-devspace
```

Create the PVs:

```bash
kubectl create -f deploy/examples/kind/loft-devspace-pvcs.yaml
```

In other terminals, run `devspace run dev` and `devspace run dev-agent`.

### Adding a new management CRD

In order to add a new management CRD the following steps and requirements have to
be met:

1. Create a new type in `staging/src/github.com/loft-sh/api/v4/pkg/apis/management`.
2. Run the `./hack/generate-go-apis.sh` script from the root of the repo.
3. Implement the REST functions in `pkg/apiserver/registry/management`.
4. After the generation from step 2 is finished, update the
  `pkg/apiserver/registry/management/register.go` file to include the new REST APIs.

### Adding a new storage CRD

Storage CRDs can be added by performing the following steps:

1. Create a new type in `staging/src/github.com/loft-sh/api/v4/pkg/apis/storage`.
2. Register it in `pkg/crdtypes/crdtypes.go`.
3. Run the `./hack/generate-go-apis.sh` script from the root of the repo.
4. Implement the controller in `pkg/manager/management/controllers`.
5. Register the implemented controller in `pkg/manager/management/register.go`.

### Adding a new agent CRD

Agents manage two groups of CRDs, cluster CRDs (existing in the target cluster)
and storage CRDs.

#### Cluster CRD

A cluster CRD can be added in an analogous manner to management CRDs:

1. Create a new type in `staging/src/github.com/loft-sh/agentapi/v4/pkg/apis/loft/cluster`.
2. Run the `./hack/generate-agent-go-apis.sh` script from the root of the repo.
3. Implement the REST functions in `pkg/agent/apiserver/registry/loft`.
4. After the generation from step 2 is finished, update the
  `pkg/agent/apiserver/registry/register.go` file to include the new REST APIs.

#### Agent storage CRD

An agent storage CRD can be added in an analogous manner to loft's storage CRDs:

1. Create a new type in `staging/src/github.com/loft-sh/agentapi/v4/pkg/apis/loft/storage`.
2. Register it in `pkg/agent/crdtypes/crdtypes.go`.
3. Run the `./hack/generate-agent-go-apis.sh` script from the root of the repo.
4. Implement the controller in `pkg/agent/manager/controllers`.
5. Register the implemented controller in `pkg/agent/manager/controllers/register.go`.

### Adding a custom REST API to loft

In order to add a new REST API route to loft, one has to:

1. Implement a new, custom handler in `pkg/apigateway/handler`. The handler logic
  can either reside in a separate package in the `pkg/apigateway` folder or be
  directly proxied/requested from a remote cluster.
2. Append the new handler to the handlers slices in `pkg/apigateway/handler/default.go`.

### Vendored dependencies - Adding a new dependency

Loft uses vendored dependencies both as a personal preference and for the ability
to symlinking to folder higher in the hierarchy due to go dependency management requirements.

**A new dependency can be added by:**

1. Add dependency to go.mod
2. Run `./hack/update-vendor.sh` to update the vendored dependencies

### Updating PlatformConfig

If you made any changes in `pkg/config/vcluster/config.go` please run
`go run ./hack/config/main.go` and commit generated jsonschema (`pkg/config/vcluster/platform.schema.json`).

### Running e2e tests

In order to run all e2e tests for loft, execute:

```bash
just e2e
```

In order to execute specific e2e tests, execute:

```bash
just e2e "test_core test_vault"
```

### Running loft with docker

1. Build the image `ghcr.io/loft-sh/enterprise:release-test`

    ```bash
    just build-image
    ```

2. Run container

    ```bash
    docker run -p 8080:10443 ghcr.io/loft-sh/enterprise:release-test
    ```

The default credentials are `username: admin`, `password: loft`

### Creating and connecting to another host cluster

> 💡
> The following assumes `kind` is installed

Start the platform on localhost:8080 as describe in the local setup above and login

- `just create-kind`
- `just dev`
- `vcluster login localhost:8080 --insecure=true`

Add an external cluster

- `just deploy-agent`

> 💡
> `deploy-agent` will create a cluster called `agent` by default, but you can pass
your own cluster name to create multiple external clusters.

<!-- Links -->

[Just]: https://github.com/casey/just "Just"
[devspace]: https://github.com/devspace-sh/devspace "Devspace"
[zellij]: https://github.com/zellij-org/zellij "zellij"
[mkcert]: https://github.com/FiloSottile/mkcert "mkcert"
[k9s]: https://github.com/derailed/k9s "k9s"
# core-app-infra
