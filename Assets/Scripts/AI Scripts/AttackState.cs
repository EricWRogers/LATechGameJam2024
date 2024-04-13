using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using SuperPupSystems.Helper;
using SuperPupSystems.StateMachine;
using UnityEngine.AI;
using UnityEngine.Events;
using static UnityEngine.GraphicsBuffer;

[System.Serializable]
public class AttackState : SimpleState
{
    public Timer time;
    public UnityEvent attack;  
    public UnityEvent stopAttacking;
    public NavMeshAgent agent;
    private bool playerInRange;
    public bool isAttacking;



    public override void OnStart()
    {
        Debug.Log("Attack State");
        base.OnStart();
        time.StartTimer(2, true);
        if (attack == null)
            attack = new UnityEvent();
        if(stateMachine is BasicEnemyStateMachine)
            agent.SetDestination(((BasicEnemyStateMachine)stateMachine).transform.position);

        if (stateMachine is RangedEnemyStateMachine)
            agent.SetDestination(((RangedEnemyStateMachine)stateMachine).transform.position);

    }

    public override void UpdateState(float dt)
    {
        if (stateMachine is RangedEnemyStateMachine)
        {
            ((RangedEnemyStateMachine)stateMachine).transform.LookAt(((RangedEnemyStateMachine)stateMachine).target);
            if (((RangedEnemyStateMachine)stateMachine).LOS == true && !isAttacking)
            {
                Debug.Log("Attaking");
                isAttacking = true;
                attack.Invoke();
            
            }
            if (((RangedEnemyStateMachine)stateMachine).LOS == false)
            {
                time.autoRestart = false;
                if(time.timeLeft <= 0)
                {
                    isAttacking = false;
                    stopAttacking.Invoke();
                    stateMachine.ChangeState(nameof(MoveInRangeState));
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
