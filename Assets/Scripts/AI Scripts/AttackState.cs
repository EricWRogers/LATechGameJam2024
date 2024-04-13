using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using SuperPupSystems.Helper;
using SuperPupSystems.StateMachine;
using UnityEngine.AI;
using Unity.VisualScripting;
using UnityEngine.Events;
using System.Threading;
using static UnityEngine.GraphicsBuffer;

[System.Serializable]
public class AttackState : SimpleState
{
    public UnityEvent attack;    
    public NavMeshAgent agent;
    public float attackRange;
    private bool playerInRange;
    private bool isAttacking;


    public override void OnStart()
    {
        Debug.Log("Attack State");
        base.OnStart();
        if (attack == null)
            attack = new UnityEvent();
        ((RangedEnemyStateMachine)stateMachine).transform.LookAt(((RangedEnemyStateMachine)stateMachine).target);
        agent.SetDestination(((RangedEnemyStateMachine)stateMachine).target.position);

    }

    public override void UpdateState(float dt)
    {
        playerInRange = Physics.CheckSphere(((RangedEnemyStateMachine)stateMachine).transform.position, attackRange, LayerMask.GetMask("Player"));
        if(playerInRange && !isAttacking)
        {
            agent.SetDestination(((RangedEnemyStateMachine)stateMachine).transform.position);
            isAttacking = true;
            attack.Invoke();
        }
        
    }
    public override void OnExit()
    {
        base.OnExit();


    }
}
