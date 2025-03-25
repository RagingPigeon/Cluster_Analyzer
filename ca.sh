#!/bin/bash

: '

+---------------+-------+
| Resource      | Total |
+---------------+-------+
| Pods          |       |
| Deployments   |       |
| Stateful Sets |       |
| Daemonsets    |       |
+---------------+-------+
| Namespaces    |       |
| Jobs          |       |
| Cron Jobs     |       |
| PVs           |       |
| PVCs          |       |
+---------------+-------+

'

clear

# Function to count resources
total_pods=$(kubectl get pods --all-namespaces --no-headers | wc -l)
total_deployments=$(kubectl get deployments --all-namespaces --no-headers | wc -l)
total_statefulsets=$(kubectl get statefulsets --all-namespaces --no-headers | wc -l)
total_daemonsets=$(kubectl get daemonsets --all-namespaces --no-headers | wc -l)
total_namespaces=$(kubectl get namespaces --no-headers | wc -l)
total_jobs=$(kubectl get jobs --all-namespaces --no-headers | wc -l)
total_cronjobs=$(kubectl get cronjobs --all-namespaces --no-headers | wc -l)
total_pvs=$(kubectl get pv --no-headers | wc -l)
total_pvcs=$(kubectl get pvc --all-namespaces --no-headers | wc -l)

# Print the header
printf "\n%80s\n" | tr ' ' '='
printf "%40s\n" "Summary"
printf "%80s\n" | tr ' ' '='

# Print the table
printf "+---------------+-------+\n"
printf "| Resource      | Total |\n"
printf "+---------------+-------+\n"
printf "| Pods          | %5d |\n" "$total_pods"
printf "| Deployments   | %5d |\n" "$total_deployments"
printf "| Stateful Sets | %5d |\n" "$total_statefulsets"
printf "| Daemonsets    | %5d |\n" "$total_daemonsets"
printf "+---------------+-------+\n"
printf "| Namespaces    | %5d |\n" "$total_namespaces"
printf "| Jobs          | %5d |\n" "$total_jobs"
printf "| Cron Jobs     | %5d |\n" "$total_cronjobs"
printf "| PVs           | %5d |\n" "$total_pvs"
printf "| PVCs          | %5d |\n" "$total_pvcs"
printf "+---------------+-------+\n"

# Print the header for Deployments
printf "\n%80s\n" | tr ' ' '='
printf "%40s\n" "Deployments"
printf "%80s\n" | tr ' ' '='

# Print the table header for Deployments
printf "+-------------------------------------------------+-------------------------------------------------+---------------+\n"
printf "| %-47s | %-47s | %-13s |\n" "Deployment Name" "Pod Name" "Namespace"
printf "+-------------------------------------------------+-------------------------------------------------+---------------+\n"
kubectl get pods --all-namespaces -o json | jq -r '.items[] | select(.metadata.ownerReferences and (.metadata.ownerReferences[].kind=="ReplicaSet")) | {namespace: .metadata.namespace, pod: .metadata.name, deployment: .metadata.ownerReferences[].name | sub("-[^-]+$"; "") } | "| \(.deployment) | \(.pod) | \(.namespace) |"' | sort | uniq | while read line; do
    printf "| %-47.47s | %-47.47s | %-13s |\n" "$(echo "$line" | cut -d'|' -f2 | xargs)" "$(echo "$line" | cut -d'|' -f3 | xargs)" "$(echo "$line" | cut -d'|' -f4 | xargs)"
done
printf "+-------------------------------------------------+-------------------------------------------------+---------------+\n"

# Print the header for Stateful Sets
printf "\n%80s\n" | tr ' ' '='
printf "%40s\n" "Stateful Sets"
printf "%80s\n" | tr ' ' '='

# Print the table header for Stateful Sets
printf "+-------------------------------------------------+-------------------------------------------------+---------------+\n"
printf "| %-47s | %-47s | %-13s |\n" "Stateful Set Name" "Pod Name" "Namespace"
printf "+-------------------------------------------------+-------------------------------------------------+---------------+\n"
kubectl get pods --all-namespaces -o json | jq -r '.items[] | select(.metadata.ownerReferences and (.metadata.ownerReferences[].kind=="StatefulSet")) | "| \(.metadata.ownerReferences[].name) | \(.metadata.name) | \(.metadata.namespace) |"' | while read line; do
    printf "| %-47.47s | %-47.47s | %-13s |\n" "$(echo "$line" | cut -d'|' -f2 | xargs)" "$(echo "$line" | cut -d'|' -f3 | xargs)" "$(echo "$line" | cut -d'|' -f4 | xargs)"
done
printf "+-------------------------------------------------+-------------------------------------------------+---------------+\n"

# Print the header for Daemonsets
printf "\n%80s\n" | tr ' ' '='
printf "%40s\n" "Daemonsets"
printf "%80s\n" | tr ' ' '='

# Print the table header for Daemonsets
printf "+-------------------------------------------------+-------------------------------------------------+---------------+\n"
printf "| %-47s | %-47s | %-13s |\n" "Daemonset Name" "Pod Name" "Namespace"
printf "+-------------------------------------------------+-------------------------------------------------+---------------+\n"
kubectl get pods --all-namespaces -o json | jq -r '.items[] | select(.metadata.ownerReferences and (.metadata.ownerReferences[].kind=="DaemonSet")) | "| \(.metadata.ownerReferences[].name) | \(.metadata.name) | \(.metadata.namespace) |"' | while read line; do
    printf "| %-47.47s | %-47.47s | %-13s |\n" "$(echo "$line" | cut -d'|' -f2 | xargs)" "$(echo "$line" | cut -d'|' -f3 | xargs)" "$(echo "$line" | cut -d'|' -f4 | xargs)"
done
printf "+-------------------------------------------------+-------------------------------------------------+---------------+\n"



# # Print the header for Pods per Namespace
# printf "\n%80s\n" | tr ' ' '='
# printf "%40s\n" "Pods"
# printf "%80s\n" | tr ' ' '='

# # Print the table header for Pods per Namespace
# printf "+---------------+-------+\n"
# printf "| Namespace     | Pods  |\n"
# printf "+---------------+-------+\n"

# # Get the count of pods per namespace and print the table
# kubectl get pods --all-namespaces --no-headers | awk '{count[$1]++} END {for (ns in count) printf "| %-13s | %5d |\n", ns, count[ns]}'
# printf "+---------------+-------+\n"


# declare -A 

# # This function parses output from the "kubectl api-resources" command.
# parse_api_resources(){
    

#     read headerline
#     echo "$headerline"
#     echo "--------------------------------"

#     while read line; do
#         #                Name
#         #                |       Spaces, Shortnames, Spaces, Apiversion, Spaces
#         #                |       | Namespaced
#         #                |       | |               Spaces
#         #                |       | |               |  Kind
#         #                |       | |               |  |
#         if [[ ${line} =~ ([a-z]+).*("true"|"false")\s*([a-zA-Z]*) ]]; then
#             NAME=${BASH_REMATCH[1]}
#             NAMESPACED=${BASH_REMATCH[2]}
#             KIND=${BASH_REMATCH[3]}

#             #echo "${line}"
#             #echo "${NAME}"
#             #echo "${NAMESPACED}"
#             #echo "${KIND}"
#             echo "${NAME}:${NAMESPACED}:${KIND}"
#         fi
#     done
# }





# parse_api_resources < <(kubectl api-resources)

