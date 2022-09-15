export PATH=${PATH}:/usr/local/bin

function get_task_definiton() {
    local SERVICE=$1
    local CLUSTER=$2
    TASK=$(aws ecs describe-services --service $SERVICE --cluster $CLUSTER | jq '.services[0] | .taskDefinition')
    echo $TASK
}

function export_task_definiton() {
    local SERVICE=$1
    local CLUSTER=$2
    TASK=$(aws ecs describe-services --service $SERVICE --cluster $CLUSTER | jq '.services[0] | .taskDefinition')
    echo $TASK
}

function get_task_version() {
    local TASK_DEFINITION=$1
    echo $TASK_DEFINITION | cut -d '/' -f 2 | cut -d : -f 2 | tr -d '"'

}
function get_task_family() {
    local TASK_DEFINITION=$1
    echo $TASK_DEFINITION | cut -d '/' -f 2 | cut -d : -f 1

}

function increment() {
    local VAR=$1
    VAR=$((VAR+1))
    echo $VAR
}

function register_task_definition() {
    local SERVICE=$1
    local CLUSTER=$2
    local TASK_FAMILY=$3
    local TASK=$4

}

function update_task_definition() {
    local TASK_DEFINITION=$1
    VERSION=$(get_task_version $TASK_DEFINITION)
    FAMILY=$(get_task_family $TASK_DEFINITION)

    N_VERSION=$(increment $VERSION)
    echo $FAMILY:$N_VERSION
}

function update_service() {
    local SERVICE=$1
    local CLUSTER=$2
    local COUNT=2


    TASK_DEFINITION=$(get_task_definiton "$SERVICE" "$CLUSTER")
    N_TASK_DEFINITION=$(update_task_definition "$TASK_DEFINITION")
    TASK_FAMILY=$(get_task_family "$N_TASK_DEFINITION")
    TASK_VERSION=$(get_task_version "$N_TASK_DEFINITION")

    TASK=$(aws ecs describe-task-definition --cluster "$CLUSTER" --task-definition "${TASK_FAMILY}:${TASK_VERSION}")

    register_task_definition "$SERVICE" "$CLUSTER" "$TASK_FAMILY" "$TASK"


    aws ecs update-service --cluster "$CLUSTER" --service "$SERVICE" --task-definition "${TASK_FAMILY}:${TASK_VERSION}" --desired-count $COUNT
}

update_service $1 $2