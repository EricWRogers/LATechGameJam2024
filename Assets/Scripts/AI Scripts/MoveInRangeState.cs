using SuperPupSystems.StateMachine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

[System.Serializable]

public class MoveInRangeState : SimpleState
{
    NavMeshAgent agent;

    public override void OnStart()
    {
        Debug.Log("Move State");
        base.OnStart();

        if (stateMachine is RangedEnemyStateMachine)
            agent = ((RangedEnemyStateMachine)stateMachine).GetComponent<NavMeshAgent>();

        if (stateMachine is BasicEnemyStateMachine)
            agent = ((BasicEnemyStateMachine)stateMachine).GetComponent<NavMeshAgent>();

        if (stateMachine is ChargeStatMachine)
            agent = ((ChargeStatMachine)stateMachine).GetComponent<NavMeshAgent>();

        if (stateMachine is HealerStateMachine)
            agent = ((HealerStateMachine)stateMachine).GetComponent<NavMeshAgent>();


        if (stateMachine is RangedEnemyStateMachine)
        {
            if(((RangedEnemyStateMachine)stateMachine).isAlive == true)
                agent.SetDestination(((RangedEnemyStateMachine)stateMachine).target.position);
        }
        if (stateMachine is BasicEnemyStateMachine)
        {
            if (((BasicEnemyStateMachine)stateMachine).isAlive == true)
                agent.SetDestination(((BasicEnemyStateMachine)stateMachine).target.position);
        }
        if (stateMachine is ChargeStatMachine)
        {
            if (((ChargeStatMachine)stateMachine).isAlive == true)
                agent.SetDestination(((ChargeStatMachine)stateMachine).target.position);
        }
        if (stateMachine is HealerStateMachine)
        {
            if (((HealerStateMachine)stateMachine).isAlive == true)
                agent.SetDestination(((HealerStateMachine)stateMachine).target.transform.position);
        }
    }

    public override void UpdateState(float dt)
    {
        if (stateMachine is RangedEnemyStateMachine)
        {
            if (((RangedEnemyStateMachine)stateMachine).isAlive == true)
            {
                agent.SetDestination(((RangedEnemyStateMachine)stateMachine).target.position);
                if (((RangedEnemyStateMachine)stateMachine).LOS)
                {
                    stateMachine.ChangeState(nameof(AttackState));
                }
            }


            if (((RangedEnemyStateMachine)stateMachine).isAlive == true)
            {
                if (((RangedEnemyStateMachine)stateMachine).Flee)
                {
                    stateMachine.ChangeState(nameof(FleeState));
                }
            }
        }
        

        if (stateMachine is BasicEnemyStateMachine)
        {
            if (((BasicEnemyStateMachine)stateMachine).isAlive == true)
            { 
                agent.SetDestination(((BasicEnemyStateMachine)stateMachine).target.position);
                if (((BasicEnemyStateMachine)stateMachine).LOS)
                {
                    stateMachine.ChangeState(nameof(AttackState));
                }
            }
        }
        if (stateMachine is ChargeStatMachine)
        {
            if (((ChargeStatMachine)stateMachine).isAlive == true)
            {
                agent.SetDestination(((ChargeStatMachine)stateMachine).target.position);
                if (((ChargeStatMachine)stateMachine).LOS)
                {
                    stateMachine.ChangeState(nameof(ChargeState));
                }
            }
        }

        if (stateMachine is HealerStateMachine)
        {
            if (((HealerStateMachine)stateMachine).isAlive == true)
            {
                agent.SetDestination(((HealerStateMachine)stateMachine).target.transform.position);
                if (((HealerStateMachine)stateMachine).LOS)
                {
                    stateMachine.ChangeState(nameof(HealState));
                }
            }
        }
    }

    public override void OnExit()
    {
        base.OnExit();


    }
}
