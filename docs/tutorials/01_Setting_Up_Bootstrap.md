Configuring Bootstrap 

Recommended Bootstrap Order:
1. MetalLB (for LoadBalancer services)
2. ArgoCD (GitOps engine)
3. Traefik (ingress controller)

I have made it easy so create config files for Metallb, Argocd and traefik in bootstrap/manifests/<app_name>/config.yaml

Then make a values file in infrastructure/<app_name>/values-production.yaml; this holds the helm charts and allows you to specify resource limits etc. (Traefik is built in so it is only configured in the infrastructure directory).

Run the ansible playbook `platform_bootstrap.yaml`:
ansible-playbook playbooks/platform_bootstrap.yaml --ask-become

Reset change argocd password (or leave it until we setup a vault with MFA?)
Download argocd on your local machine. mac: `brew install argocd`
Login to argo with playbook details:

- argocd login <ARGOCD_LOADBALANCER_IP> --username admin --password <CURRENT_PASSWORD> --insecure
- argocd account update-password

Verify password updated:

- argocd login <ARGOCD_IP> --username admin --password <NEW_PASSWORD> --insecure
- argocd cluster list

Delete the inital secret:

- ssh onto the master node/s
- kubectl -n argocd delete secret argocd-initial-admin-secret


