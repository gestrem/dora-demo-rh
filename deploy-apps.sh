# gitops filder

# create placement objects if not created
oc create -f gitops/placements/apps-placement.yaml
oc create -f gitops/placements/location-placement.yaml


# create hub-apis sa and generate token with cluster-admin role
oc create sa hub-apis
# create token valid for 10days
oc create token hub-apis --duration 14400m
# a secret will be created with the token that can be used fot he API calls (hub-apis-token-XXXXX)
oc adm policy add-cluster-role-to-user cluster-admin system:serviceaccount:hub-ns:hub-apis
# curl -k -H "Authorization: Bearer TOKEN" "https://api.cluster-sql9s.sql9s.[Base DNS Domain]:6443/apis/policy.open-cluster-management.io/v1/namespaces/openshift-gitops/policies/hub-ns"


# create hub-apis-token secret
cat <<EOF | oc apply -f -
kind: Secret
apiVersion: v1
metadata:
  name: hub-apis-token
  namespace: hub-ns
data:
  token: ZXlKaGJHY2lPaUpTVXpJMU5pSXNJbXRwWkNJNklrRmhkV3RVY3pWS2FuVTJUSE5VZUhSVGNtdEpPRk4wTFhRM2NWSkNOSGRpVURSSk1WbzJNSGhuWkVVaWZRLmV5SmhkV1FpT2xzaWFIUjBjSE02THk5cmRXSmxjbTVsZEdWekxtUmxabUYxYkhRdWMzWmpJbDBzSW1WNGNDSTZNVGN6T0RVM05EVXhNeXdpYVdGMElqb3hOek0zTnpFd05URXpMQ0pwYzNNaU9pSm9kSFJ3Y3pvdkwydDFZbVZ5Ym1WMFpYTXVaR1ZtWVhWc2RDNXpkbU1pTENKcWRHa2lPaUkwTXpZMk1XWXdNeTFpWmpFNExUUmtaRGt0WVRJeVl5MDJObUprWlRWbE5EY3lZalVpTENKcmRXSmxjbTVsZEdWekxtbHZJanA3SW01aGJXVnpjR0ZqWlNJNkltaDFZaTF1Y3lJc0luTmxjblpwWTJWaFkyTnZkVzUwSWpwN0ltNWhiV1VpT2lKb2RXSXRZWEJwY3lJc0luVnBaQ0k2SW1Fd01qVTBPR1JpTFRnM1lqWXROR001WmkxaU1XTTRMVEV4T0RVeU9HTXpZek5pT1NKOWZTd2libUptSWpveE56TTNOekV3TlRFekxDSnpkV0lpT2lKemVYTjBaVzA2YzJWeWRtbGpaV0ZqWTI5MWJuUTZhSFZpTFc1ek9taDFZaTFoY0dsekluMC5uV3YyUDY3ckxqYUhtWHBJMlpqelFOR05ZdEpJUjBVNFpSei0zUlJhTmRXc196cG5tUXdRa05uOGx3akVGbjFoMmFxZ2t2eTdpVkJnODlEODFjZ3FLaGdCUEhSbUU0bkJGdXhyUDFEUzVNQWh6a0JaalhBMnI4NzE4UzdLYXBienlWUUpvMEU5aGswejVqV1ExZ1p4SVlPTEpFLXZMRTlQaGdzdTRQY3Z3Uk5UOW9rRXh0dGE1c3BweS0xUi04UDM4OWpuQ05nUWdJRTFiM2NjM3M3d3doR1AtWDZ5TU41eGhWWE9kbmpwOVVjRFI4M2Y5YnVzVkZUR2tXQUp5dERSTnZGMGZYVGw4Y1ZVdnpjOHhoa2ZYYlluTlk2SEluU2RnbFlBMEtFUVluYXZsMU0zMG9sbU9BNk9GZmlka0twMkFoRm03ZlJPd2ZOcEtmM0J4MklockV3blhUeHBfQUxfNjgyb192QTBWUEQyRFJhSWZveWdDaW1DdnFBS0tmV0lvMnNqVWJNUEdPdWZGWXhmVUlLNDhnNjVFNU16Y3ZYLTNZN0RVdlRQaUl3cTd6bXllX0pPRkZ1aDlZTVhBU2ZjUlI2SkpnNzJBS0hTczdNT0EzNnNSS3FYUWZBczBCdHc4STA3MDVrNjhNeGktbjY3OW9WYkNtTG1YY0RkWWdOZ29qSTFwdkVoUW9paEVWSlI0dEgyajRWaGdrcnlDUDBhaUdRUUFLR1JSMFp5ckpXMWdORjBUME9oYmlQdklsYU1Pbks4TmdTNURwWThRdFU3M1NpcDJTel9weVUteW1ZekhzTTUwc2lQQTNFMkJHMktHZGJiZVFoRGEyZHQ1RDU3YVdHSmNkRHN0WF93VVVVZHFxTmRSckNiVXdZR0tJMF8yeG51Z214VzhnWQ==
type: Opaque
EOF

oc create -f gitops/placements/argocd-placement.yaml


# once secret is created, then deploy the dashboard app
# deploy dashboard app
oc create -f gitops/dashboard-applicationset.yaml -n openshift-gitops



# delete 
#oc delete  -f gitops/dashboard-applicationset.yaml -n openshift-gitops

