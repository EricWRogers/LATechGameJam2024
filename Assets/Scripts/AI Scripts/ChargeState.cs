using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using SuperPupSystems.Helper;
using SuperPupSystems.StateMachine;
using UnityEngine.AI;
using UnityEngine.Events;
using static UnityEngine.GraphicsBuffer;


[System.Serializable]
public class ChargeState : SimpleState
{
    public Timer time;
    public NavMeshAgent agent;
    public float power;
    public float radius;
    public int dmg;
    Health health;


    public override void OnStart()
    {
        Debug.Log("Charge State");
        base.OnStart(); 
        agent.SetDestination(((ChargeStatMachine)stateMachine).transform.position);
        Explode();
        //rb.AddExplosionForce(power, ((ChargeStatMachine)stateMachine).target.position, radius, 0);
    }

    public override void UpdateState(float _dt)
    {
            base.UpdateState(_dt);
        
    }
    public void Explode()
    {
        Collider[] colliders = Physics.OverlapSphere(((ChargeStatMachine)stateMachine).transform.position, radius);

        foreach(Collider hit in colliders)
        {
            Debug.Log("BOOM");
            //hit.GetComponent<Health>()?.Damage(dmg);
            if(hit.transform.parent)
                hit.transform.parent.GetComponentInChildren<Health>()?.Damage(dmg);
            else
                hit.GetComponentInChildren<Health>()?.Damage(dmg);

        }
    }
}
