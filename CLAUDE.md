# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a GitOps-based Kubernetes infrastructure project for a home lab environment. It uses K3s on Raspberry Pi 5 hardware with ArgoCD implementing the "Apps of Apps" pattern. The goal is to create a production-like environment for practicing SRE principles.

**Hardware**: 3 master nodes + 3 worker nodes (Raspberry Pi 5s) in a 10-inch 8U server rack.

## Key Commands

### Bootstrap Ansible Playbooks
Run from `bootstrap/ansible/`:
```bash
# Initial OS setup on all nodes
ansible-playbook playbooks/node_setup.yaml

# Install K3s cluster
ansible-playbook playbooks/cluster_setup.yaml

# Bootstrap platform (MetalLB + ArgoCD + Apps of Apps)
ansible-playbook playbooks/platform_setup.yaml

# Other utilities
ansible-playbook playbooks/node_update.yaml       # Update nodes
ansible-playbook playbooks/cluster_shutdown.yaml  # Shutdown cluster
ansible-playbook playbooks/node_system_info.yaml  # Get system info
```

### Environment Variables Required
Node IPs are configured via environment variables: `M01_IP`, `M02_IP`, `M03_IP` (masters), `W01_IP`, `W02_IP`, `W03_IP` (workers), `MLB_IP` (MetalLB range).

## Architecture

### GitOps Pattern
- **ArgoCD ApplicationSet** at `platform/apps_of_apps/aoa-production.yaml` dynamically generates Applications from git directories
- ArgoCD watches `platform/environments/production/infrastructure/` and `platform/environments/production/applications/`
- Generated apps use naming pattern `{basename}-production` (e.g., `grafana.yaml` becomes `grafana-production` app)
- Automated sync with prune and self-heal enabled

### Naming Conventions
- ArgoCD Applications: `{component}-production` (e.g., `prometheus-production`, `grafana-production`)
- Internal service URLs: `http://{app-name}.{namespace}.svc.cluster.local:{port}`
- Example: `http://prometheus-production.monitoring.svc.cluster.local:80`

### Directory Structure
- `bootstrap/ansible/` - Ansible playbooks (`playbooks/`) and inventory (`inventories/hosts.yaml`) for initial cluster setup
- `infrastructure/` - Helm chart values files for each component (prometheus, grafana, istio, etc.)
- `platform/environments/production/infrastructure/` - ArgoCD Application manifests that reference the infrastructure Helm values
- `platform/environments/production/applications/` - Application deployments (placeholder)
- `operations/` - Dashboards, auto-remediation policies
- `docs/` - Tutorials, runbooks, templates

### Infrastructure Stack
- **Kubernetes**: K3s (ARM64)
- **Load Balancer**: MetalLB (v0.13.12)
- **Service Mesh**: Istio (v1.23.2)
- **Storage**: Longhorn (v1.9.1)
- **Observability**: Prometheus + Grafana + AlertManager + Loki + Promtail + Jaeger + OpenTelemetry + Kiali
- **GitOps**: ArgoCD
- **Security**: Sealed Secrets, Cert-Manager, Keycloak/Dex

### Adding New Infrastructure
1. Create Helm values file in `infrastructure/<component>/values-production.yaml`
2. Create ArgoCD Application manifest in `platform/environments/production/infrastructure/<component>.yaml`
3. ArgoCD automatically picks up new applications via the ApplicationSet

## Resource Constraints

All components are sized for Raspberry Pi hardware. When modifying resource requests/limits, stay within ARM64 constraints (typical: 100-500m CPU, 256Mi-1Gi RAM per component).
