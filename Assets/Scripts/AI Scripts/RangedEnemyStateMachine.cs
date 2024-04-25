using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using SuperPupSystems.Helper;
using SuperPupSystems.StateMachine;
using UnityEngine.AI;

public class RangedEnemyStateMachine : SimpleStateMachine
{
    public FleeState flee;
    public MoveInRangeState moveInRange;
    public AttackState shoot;

    public bool LOS;
    public bool Flee;
    public Transform target;
    public bool isAlive;
    public int ranMinFlee;
    public int ranMaxFlee;

    private void Awake()
    {
        states.Add(flee);
        states.Add(moveInRange);
        states.Add(shoot);

        foreach (SimpleState s in states)
            s.stateMachine = this;

        
    }

    void Start()
    {
        target = GameObject.FindGameObjectWithTag("Player").transform;

        ChangeState(nameof(MoveInRangeState));
    }
    void Update()
    {
        if (GetComponentInChildren<Health>().currentHealth > 0)
            isAlive = true;
        else
            isAlive = false;
        LOS = gameObject.GetComponent<FOV>().targetsInSight;
        Flee = gameObject.GetComponent<FleeRange>().targetsInSight;


    }

}
