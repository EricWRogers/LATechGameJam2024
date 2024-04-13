using SuperPupSystems.StateMachine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

[System.Serializable]

public class MoveInRangeState : SimpleState
{
    public NavMeshAgent agent;
    private bool inRange;

    public override void OnStart()
    {
        base.OnStart();
        agent.SetDestination(((RangedEnemyStateMachine)stateMachine).target.position);
    }

    public override void UpdateState(float dt)
    {
        agent.SetDestination(((RangedEnemyStateMachine)stateMachine).target.position);
        if (((RangedEnemyStateMachine)stateMachine).LOS)
        {
            stateMachine.ChangeState(nameof(AttackState));
        }
    }

    public override void OnExit()
    {
        base.OnExit();


    }
}
