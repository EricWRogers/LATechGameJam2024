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
    


    public override void OnStart()
    {
        Debug.Log("Charge State");
        base.OnStart(); 
        agent.SetDestination(((ChargeStatMachine)stateMachine).transform.position);
        ((ChargeStatMachine)stateMachine).Explode();
    }

    public override void UpdateState(float _dt)
    {
            base.UpdateState(_dt);
        
    }
    
}
