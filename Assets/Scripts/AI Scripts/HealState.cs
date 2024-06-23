using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using SuperPupSystems.Helper;
using SuperPupSystems.StateMachine;
using UnityEngine.AI;
using UnityEngine.Events;
using static UnityEngine.GraphicsBuffer;
using System.Linq;

[System.Serializable]
public class HealState : SimpleState
{
    NavMeshAgent agent;
    private bool playerInRange;
    private float nextFireTime;
    public float fireRate = 0.2f;
    public List<int> enemyHp = new List<int>();

    public override void OnStart()
    {
        Debug.Log("Heal State");
        base.OnStart();

        
        agent = ((HealerStateMachine)stateMachine).GetComponent<NavMeshAgent>();
        agent.SetDestination(((HealerStateMachine)stateMachine).transform.position);
    }

    public override void UpdateState(float dt)
    {
        enemyHp.Clear();
        for (int i = 0; i <= ((HealerStateMachine)stateMachine).gameObject.GetComponent<HealRange>().visibleTargets.Count - 1; i++)
        {
            if(((HealerStateMachine)stateMachine).gameObject.GetComponent<HealRange>().visibleTargets.Count != 0)
                enemyHp.Add(((HealerStateMachine)stateMachine).gameObject.GetComponent<HealRange>().visibleTargets[i].GetComponentInChildren<Health>().currentHealth);
        }
        
        for(int i = 0;i <= ((HealerStateMachine)stateMachine).gameObject.GetComponent<HealRange>().visibleTargets.Count - 1; i++)
        {
            if (((HealerStateMachine)stateMachine).gameObject.GetComponent<HealRange>().visibleTargets.Count != 0)
            {
                int lowestHp = enemyHp.Min();
                Debug.Log("Lowest HP is " + lowestHp);
                if (((HealerStateMachine)stateMachine).gameObject.GetComponent<HealRange>().visibleTargets[i].GetComponentInChildren<Health>().currentHealth == lowestHp)
                {
                    Debug.Log("" + ((HealerStateMachine)stateMachine).gameObject.GetComponent<HealRange>().visibleTargets[i]);
                    ((HealerStateMachine)stateMachine).target = ((HealerStateMachine)stateMachine).gameObject.GetComponent<HealRange>().visibleTargets[i];
                }
            }
        }

        Heal();

        if (((HealerStateMachine)stateMachine).LOS == false)
        {
                
            stateMachine.ChangeState(nameof(MoveInRangeState));
            
        }
    }

    private void Heal()
    {
        ((HealerStateMachine) stateMachine).transform.LookAt(((HealerStateMachine) stateMachine).target.transform);
        if (((HealerStateMachine) stateMachine).inHealRange == true && Time.time >= nextFireTime)
        {
            nextFireTime = Time.time + fireRate;

            if (((HealerStateMachine) stateMachine).target.GetComponentInChildren<Health>().currentHealth<((HealerStateMachine) stateMachine).target.GetComponentInChildren<Health>().maxHealth)
            {
                Debug.Log("Healed");

                ((HealerStateMachine) stateMachine).target.GetComponentInChildren<Health>().Heal(((HealerStateMachine) stateMachine).healAmount);
                Debug.Log("targets health" + ((HealerStateMachine) stateMachine).target.GetComponentInChildren<Health>().currentHealth);
            }
        }
    }
    
    public override void OnExit()
    {
        base.OnExit();


    }
}
