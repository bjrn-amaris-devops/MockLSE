

function get_task_definiton() {
    SERVICE=$1
    CLUSTER=$2
    TASK=$(aws ecs describe-services --service $SERVICE --cluster $CLUSTER | jq '.services[0] | .taskDefinition')
    echo $TASK
}

function export_task_definiton() {
    SERVICE=$1
    CLUSTER=$2
    TASK=$(aws ecs describe-services --service $SERVICE --cluster $CLUSTER | jq '.services[0] | .taskDefinition')
    echo $TASK
}

function get_task_version() {
    TASK_DEFINITION=$1
    echo $TASK_DEFINITION | cut -d : -f 2

}
function get_task_family() {
    TASK_DEFINITION=$1
    echo $TASK_DEFINITION | cut -d : -f 1

}

function increment() {
    VAR=$1
    VAR=$((VAR+1))
    echo $VAR
}

function register_task_definition() {
    SERVICE=$1
    CLUSTER=$2
    TASK_FAMILY=$3
    TASK=$4

}

function update_task_definition() {
    TASK_DEFINITION=$1
    VERSION=$(get_task_version $TASK_DEFINITION)
    FAMILY=$(get_task_family $TASK_DEFINITION)

    N_VERSION=$(increment $VERSION)
    echo $FAMILY:$N_VERSION
}

function update_service() {
    SERVICE=$1
    CLUSTER=$2
    COUNT=2

    TASK_DEFINITION=$(get_task_definiton $SERVICE $CLUSTER)
    N_TASK_DEFINITION=$(update_task_definition $TASK_DEFINITION)
    TASK_FAMILY=$(get_task_family $N_TASK_DEFINITION)

    TASK=$(aws ecs describe-task-definition --task-definition $TASK_DEFINITION)

    register_task_definition $CLUSTER $SERVICE $TASK_FAMILY $TASK


    aws ecs update-service --cluster $CLUSTER --service $SERVICE --task-definition $N_TASK_DEFINITION --desired-count $COUNT
}

update_service $1 $2