# External Secrets Bitwarden

A Helm chart for using Bitwarden with External Secrets Operator in Kubernetes.

## Purpose

This is a chart to use (vaultwarden)[https://github.com/dani-garcia/vaultwarden] or even (bitwarden)[https://bitwarden.com] with kubernetes secrets.

> [!NOTE]
> This is not similar to bitwarden kubernetes operator, which uses bitwarden as a secrets manager under the hood.

### Usage

```bash
helm repo add eznix86 https://eznix86.github.io/bitwarden-external-secrets

helm repo update

helm install bitwarden-external-secrets eznix86/bitwarden-external-secrets \
  -n bitwarden-external-secrets \
  --create-namespace \
  --set secrets.bw_clientid="" \
  --set secrets.bw_clientsecret="" \
  --set secrets.bw_password="" # used to decrypt your vault
```

`bw_clientid` and `bw_clientsecret` can be found on your vaultwarden/bitwarden app settings.

# Supported Fields


| Field | Supported | Cluster Store Name | Property |
| --- | --- | --- | --- |
| username | ✅ | bitwarden-login | username |
| password | ✅ | bitwarden-login | password |
| notes | ✅ | bitwarden-notes | - |
| custom fields | ✅ | bitwarden-fields | - |
| private key | ✅ | bitwarden-ssh-key | privateKey |
| public key | ✅ | bitwarden-ssh-key | publicKey |
| key fingerprint | ✅ | bitwarden-ssh-key | keyFingerprint |
| attachments* | ❌ | - | - |

### Example

```yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: my-secrets
  namespace: bitwarden-external-secrets
spec:
  refreshPolicy: Periodic
  refreshInterval: 1m
  target:
    name: my-secrets
    deletionPolicy: Delete
    template:
      type: Opaque
      data:
        username: |
          {{ .username }}
        password: |
          {{ .password }}
        note: |
          {{ .note }}
        field: |
          {{ .field }}
        ssh_key_public: |
          {{ .ssh_key_public }}
  data:
    - secretKey: username
      sourceRef:
        storeRef:
          name: bitwarden-login 
          kind: ClusterSecretStore
      remoteRef:
        key: 075b7bad-5ce8-4904-b87f-ad4d595d64a0
        property: username
    - secretKey: password
      sourceRef:
        storeRef:
          name: bitwarden-login
          kind: ClusterSecretStore
      remoteRef:
        key: 075b7bad-5ce8-4904-b87f-ad4d595d64a0
        property: password
    - secretKey: note
      sourceRef:
        storeRef:
          name: bitwarden-notes
          kind: ClusterSecretStore
      remoteRef:
        key: 075b7bad-5ce8-4904-b87f-ad4d595d64a0
    - secretKey: field
      sourceRef:
        storeRef:
          name: bitwarden-fields
          kind: ClusterSecretStore
      remoteRef:
        key: 075b7bad-5ce8-4904-b87f-ad4d595d64a0
        property: custom-field

    - secretKey: ssh_key_public
      sourceRef:
        storeRef:
          name: bitwarden-ssh-key
          kind: ClusterSecretStore
      remoteRef:
        key: 7b0a8e1a-a54e-415b-becf-bc804449be1e
        property: publicKey # publicKey or privateKey or keyFingerprint
```

### Future Improvements

- [ ] Use (kro.run)[https://kro.run] to create a custom resource
  - blocking: (https://github.com/kro-run/kro/issues/17)[kro.run issue]

