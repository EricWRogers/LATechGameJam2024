using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using SuperPupSystems.Helper;
using SuperPupSystems.StateMachine;
using UnityEngine.AI;

public class ChargeStatMachine : SimpleStateMachine
{
    public MoveInRangeState moveInRange;
    public ChargeState Charge;

    public bool LOS;
    //public float attackZone;
    public Transform target;

    private void Awake()
    {
        states.Add(moveInRange);
        states.Add(Charge);

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

        LOS = gameObject.GetComponent<FOV>().targetsInSight;

    }

}
