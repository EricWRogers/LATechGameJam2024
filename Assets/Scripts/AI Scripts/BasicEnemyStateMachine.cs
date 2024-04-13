using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using SuperPupSystems.Helper;
using SuperPupSystems.StateMachine;
using UnityEngine.AI;
using static UnityEditor.VersionControl.Asset;

public class BasicEnemyStateMachine : SimpleStateMachine
{
    //States
    public PatrolState patrol;
    public ChaseState chase;
    public bool LOS;

    //General var
    public Rigidbody rb;

    //Patrol var
    public List<Transform> patrolPoints;

    private void Awake()
    {
        states.Add(patrol);
        states.Add(chase);

        foreach (SimpleState s in states)
            s.stateMachine = this;

        ChangeState(nameof(PatrolState));
    }

    void Start()
    {

    }

    void Update()
    {
        //LOS = LOSCHECK();
        if(LOS == true)
        {
            ChangeState(nameof(chase));
        }
    }

    /*bool LOSCHECK ()
    {
        if(seePlayer)
        {
            return true;
        }
        else
        {
            return false;
        }
    }*/
}
