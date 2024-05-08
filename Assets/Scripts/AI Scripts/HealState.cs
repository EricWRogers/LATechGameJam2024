using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using SuperPupSystems.Helper;
using SuperPupSystems.StateMachine;
using UnityEngine.AI;
using UnityEngine.Events;
using static UnityEngine.GraphicsBuffer;

[System.Serializable]
public class HealState : SimpleState
{
    NavMeshAgent agent;
    private bool playerInRange;
    private float nextFireTime;
    public float fireRate = 0.2f;

    public override void OnStart()
    {
        Debug.Log("Heal State");
        base.OnStart();

        
        agent = ((HealerStateMachine)stateMachine).GetComponent<NavMeshAgent>();
        agent.SetDestination(((HealerStateMachine)stateMachine).transform.position);
    }

    public override void UpdateState(float dt)
    {
        ((HealerStateMachine)stateMachine).transform.LookAt(((HealerStateMachine)stateMachine).target.transform);
        if (((HealerStateMachine)stateMachine).inHealRange == true && Time.time >= nextFireTime)
        {
            nextFireTime = Time.time + fireRate;

            if (((HealerStateMachine)stateMachine).target.GetComponentInChildren<Health>().currentHealth < ((HealerStateMachine)stateMachine).target.GetComponentInChildren<Health>().maxHealth)
            {
                Debug.Log("Healed");

                ((HealerStateMachine)stateMachine).target.GetComponentInChildren<Health>().Heal(((HealerStateMachine)stateMachine).healAmount);
                Debug.Log("targets health" + ((HealerStateMachine)stateMachine).target.GetComponentInChildren<Health>().currentHealth);
            }
        }
        if (((HealerStateMachine)stateMachine).LOS == false)
        {
                
            stateMachine.ChangeState(nameof(MoveInRangeState));
            
        }
    }
    public override void OnExit()
    {
        base.OnExit();


    }
}
