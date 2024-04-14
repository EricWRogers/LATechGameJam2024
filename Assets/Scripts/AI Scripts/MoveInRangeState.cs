using SuperPupSystems.StateMachine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

[System.Serializable]

public class MoveInRangeState : SimpleState
{
    public NavMeshAgent agent;


    public override void OnStart()
    {
        base.OnStart();
        if (stateMachine is RangedEnemyStateMachine)
        {
            agent.SetDestination(((RangedEnemyStateMachine)stateMachine).target.position);
        }
        if (stateMachine is BasicEnemyStateMachine)
        {
            agent.SetDestination(((BasicEnemyStateMachine)stateMachine).target.position);
        }
        if (stateMachine is ChargeStatMachine)
        {
            agent.SetDestination(((ChargeStatMachine)stateMachine).target.position);
        }
    }

    public override void UpdateState(float dt)
    {
        if (stateMachine is RangedEnemyStateMachine)
        {
            agent.SetDestination(((RangedEnemyStateMachine)stateMachine).target.position);
            if (((RangedEnemyStateMachine)stateMachine).LOS)
            {
                stateMachine.ChangeState(nameof(AttackState));
            }
        }

        if (stateMachine is BasicEnemyStateMachine)
        {
            agent.SetDestination(((BasicEnemyStateMachine)stateMachine).target.position);
            if (((BasicEnemyStateMachine)stateMachine).LOS)
            {
                stateMachine.ChangeState(nameof(AttackState));
            }
        }
        if (stateMachine is ChargeStatMachine)
        {
            agent.SetDestination(((ChargeStatMachine)stateMachine).target.position);
            if (((ChargeStatMachine)stateMachine).LOS)
            {
                stateMachine.ChangeState(nameof(ChargeState));
            }
        }
    }

    public override void OnExit()
    {
        base.OnExit();


    }
}
