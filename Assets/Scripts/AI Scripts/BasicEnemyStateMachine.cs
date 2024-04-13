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
    [Tooltip("How long it takes to switch from chase to patrol.")]
    public float delay = 0;

    //General var
    public Rigidbody rb;

    //Patrol var
    public List<Transform> patrolPoints;
    public List<Transform> targetPos;

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
        targetPos = gameObject.GetComponent<FOV>().visibleTargets;
        gameObject.GetComponent<FOV>().targetsInSight = LOS;
        
            //Debug.Log("Chasing: " + gameObject.GetComponent<FOV>().visibleTargets[0].name);
            //ChangeState(nameof(ChaseState));
        

    }
    /*
    public bool LOSCHECK()
    {
        FOV.FindVisibleTargets();
    }*/
}
