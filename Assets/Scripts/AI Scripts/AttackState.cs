using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using SuperPupSystems.Helper;
using SuperPupSystems.StateMachine;
using UnityEngine.AI;
using UnityEngine.Events;

[System.Serializable]
public class AttackState : SimpleState
{
    public Timer time;
    public UnityEvent attack;  
    public UnityEvent stopAttacking;
    NavMeshAgent agent;
    private bool playerInRange;
    public bool isAttacking;

    public override void OnStart()
    {
        Debug.Log("Attack State");
        base.OnStart();

        if (stateMachine is RangedEnemyStateMachine)
        {
            agent = ((RangedEnemyStateMachine)stateMachine).GetComponent<NavMeshAgent>();
            agent.SetDestination(((RangedEnemyStateMachine)stateMachine).transform.position);
        }


        if (stateMachine is BasicEnemyStateMachine)
        {
            agent = ((BasicEnemyStateMachine)stateMachine).GetComponent<NavMeshAgent>();
            agent.SetDestination(((BasicEnemyStateMachine)stateMachine).transform.position);
        }

        time.StartTimer(2, true);
        if (attack == null)
            attack = new UnityEvent();
    }

    public override void UpdateState(float dt)
    {
        if (stateMachine is RangedEnemyStateMachine)
        {
            ((RangedEnemyStateMachine)stateMachine).transform.LookAt(((RangedEnemyStateMachine)stateMachine).target);
            if (((RangedEnemyStateMachine)stateMachine).LOS == true && !isAttacking)
            {
                isAttacking = true;
                attack.Invoke();
            }

            if (((RangedEnemyStateMachine)stateMachine).LOS == false)
            {
                time.autoRestart = false;
                if (time.timeLeft <= 0)
                {
                    isAttacking = false;
                    stopAttacking.Invoke();
                    stateMachine.ChangeState(nameof(MoveInRangeState));
                }
            }
            
            
            if (((RangedEnemyStateMachine)stateMachine).isAlive == true)
            {
                if (((RangedEnemyStateMachine)stateMachine).Flee)
                {
                    time.autoRestart = false;
                    if (time.timeLeft <= 0)
                    {
                        isAttacking = false;
                        stopAttacking.Invoke();
                        stateMachine.ChangeState(nameof(FleeState));
                    }
                }
            }

            
        }
        if (stateMachine is BasicEnemyStateMachine)
        {
            ((BasicEnemyStateMachine)stateMachine).transform.LookAt(((BasicEnemyStateMachine)stateMachine).target);
            if (((BasicEnemyStateMachine)stateMachine).LOS == true && !isAttacking)
            {
                Debug.Log("Attaking");
                isAttacking = true;
                attack.Invoke();

                isAttacking = false;
                
            }
            if (((BasicEnemyStateMachine)stateMachine).LOS == false)
            {
                time.autoRestart = false;
                if (time.timeLeft <= 0)
                {
                    isAttacking = false;
                    stopAttacking.Invoke();
                    stateMachine.ChangeState(nameof(MoveInRangeState));
                }

            }
        }





    }
    
    public override void OnExit()
    {
        base.OnExit();


    }
}
