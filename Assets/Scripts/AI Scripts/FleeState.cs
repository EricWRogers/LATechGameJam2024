using SuperPupSystems.StateMachine;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEditor;
using UnityEngine;
using UnityEngine.AI;

[System.Serializable]

public class FleeState : SimpleState
{
    NavMeshAgent agent;
    Transform startTransform;
    public float pos;


    public override void OnStart()
    {
        Debug.Log("Flee State");
        base.OnStart();
        pos = Random.Range(((RangedEnemyStateMachine)stateMachine).ranMinFlee, ((RangedEnemyStateMachine)stateMachine).ranMaxFlee);
        agent = ((RangedEnemyStateMachine)stateMachine).GetComponent<NavMeshAgent>();

        RunAway();

    }
    public override void UpdateState(float _dt)
    {
        base.UpdateState(_dt);

        if(agent.remainingDistance <= 0)
        {
            stateMachine.ChangeState(nameof(MoveInRangeState));
        }


    }
    void RunAway()
    {
        startTransform = ((RangedEnemyStateMachine)stateMachine).transform;

        ((RangedEnemyStateMachine)stateMachine).transform.rotation = Quaternion.LookRotation(((RangedEnemyStateMachine)stateMachine).transform.position - ((RangedEnemyStateMachine)stateMachine).target.position);

        Vector3 fleePos = ((RangedEnemyStateMachine)stateMachine).transform.position + ((RangedEnemyStateMachine)stateMachine).transform.forward * pos; 

        NavMeshHit hit;

        NavMesh.SamplePosition(fleePos, out hit, 5, 1 << NavMesh.GetAreaFromName("Walkable"));

        ((RangedEnemyStateMachine)stateMachine).transform.position = startTransform.position;
        ((RangedEnemyStateMachine)stateMachine).transform.rotation = startTransform.rotation;

        agent.SetDestination(hit.position);

    }
}
