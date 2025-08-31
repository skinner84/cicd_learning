# Plan: Minimal CI/CD to k3s (Learning Path)

## Objective
Build a simple, real-world-like CI/CD flow that helps me learn step by step:
- Code in GitHub
- CI builds a container, scans it, and pushes to a registry
- CD deploys to an existing k3s cluster (local or EC2)
- Keep it simple, standard, and digestible.  
- I am learning, so I want small, followable chunks — not the tool doing everything automatically.

## Guardrails for the LLM CLI
- Always break things down into simple, clear steps I can follow.  
- Ask before creating or editing files.  
- Propose changes as drafts/diffs, not giant code dumps unless requested.  
- Use widely adopted tools: Docker, GitHub Actions, Trivy, kubectl, Helm.  
- Never store or invent secrets; just reference them.  
- Keep everything minimal and easy to understand.

## Inputs (I’ll provide these when needed)
- PROJECT_NAME (e.g. `hello`)
- REGISTRY_PROVIDER: `dockerhub` (default) or `ecr`
- DOCKERHUB_REPO (if dockerhub): `docker.io/<user>/<project>`
- AWS_ACCOUNT_ID / AWS_REGION (if ecr)
- K8S_NAMESPACE: default = `default`
- KUBECONFIG_METHOD: `kubeconfig_secret` (preferred) or `ssm_exec`
- APP_PORT: default = `8080`
- SEVERITY_THRESHOLD: `HIGH,CRITICAL`

## Deliverables
1. **Repo structure (scaffold only):**
   - `app/` (app code later)
   - `k8s/` (manifests or Helm chart later)
   - `.github/workflows/ci.yml` (build, scan, push)
   - `.github/workflows/cd.yml` (deploy, verify)
   - `README.md` (instructions, secrets checklist)
   - `plan.yaml` (records chosen settings)

2. **Secrets checklist** in `README.md`:
   - Docker Hub: `DOCKERHUB_USERNAME`, `DOCKERHUB_TOKEN`
   - ECR: GitHub OIDC role ARN
   - KUBECONFIG secret (base64 or file upload)
   - Optional: `TRIVY_TOKEN` if needed

3. **Policies & conventions** in `README.md`:
   - Tagging: `latest` for main, `branch-SHORTSHA` for others
   - CI fails on HIGH/CRITICAL scan findings
   - Manifests must include probes and non-root pod security settings

## Milestones (step by step)

### Milestone 0 — Repo scaffolding
- Create the directories and placeholder files above.  
- Document required secrets and decisions in `README.md`.  
- Acceptance: repo is scaffolded, no failing pipelines yet.

### Milestone 1 — CI only (build + scan + push)
- CI workflow runs on branch push.  
- Steps: checkout → build image → scan with Trivy → push to registry.  
- Acceptance: build passes, scan enforces severity threshold, image is pushed.

### Milestone 2 — CD to k3s with kubectl
- CD workflow runs manually or after main passes.  
- Steps: auth to cluster → apply manifests → rollout status → HTTP health check.  
- Acceptance: new version is deployed, `/health` returns 200.

### Milestone 3 — Switch to AWS ECR (optional)
- Swap registry from Docker Hub to ECR using GitHub OIDC.  
- Update workflows accordingly.  
- Acceptance: images land in ECR, k3s can pull them.

### Milestone 4 — Quality gates and environments (optional)
- Add staging vs prod environments.  
- Keep Trivy fail-on-severity.  
- Optional: simple linting for Kubernetes manifests.  
- Acceptance: separate deploys per env, approval before prod.

## Non-goals (for now)
- No GitOps (ArgoCD/Flux).  
- No ALB/Ingress/TLS.  
- No Vault or external secrets yet.  
- No multi-node cluster build-out.  

## Prompts the LLM CLI should follow
- “Scaffold the repo with placeholder files for Milestone 0.”  
- “Draft a simple CI workflow for Milestone 1.”  
- “Draft a CD workflow for Milestone 2.”  
- “Update workflows to switch registry from Docker Hub to ECR.”  
- “Add a README section for secrets and policies.”  
- Always explain the steps clearly so I can learn as I go.

## Success Criteria (for learning + interview prep)
- I can walk through the pipeline end-to-end myself.  
- I can point to security gates: image scan severity, rollout checks, health probe.  
- I can explain short-lived auth (OIDC) vs static keys.  
- I can show secure pod defaults (runAsNonRoot, readOnlyRootFS, drop caps).  

