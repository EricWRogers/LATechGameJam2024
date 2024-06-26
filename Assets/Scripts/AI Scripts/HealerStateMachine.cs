using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using SuperPupSystems.Helper;
using SuperPupSystems.StateMachine;
using UnityEngine.AI;

public class HealerStateMachine : SimpleStateMachine
{
    public MoveInRangeState moveIn;
    public HealState heal;

    public bool LOS;
    public bool inHealRange;
    public GameObject target;
    public bool isAlive;
    public int healAmount;
    private int counter;
    // Start is called before the first frame update
    void Awake()
    {
        states.Add(moveIn);
        states.Add(heal);

        foreach (SimpleState s in states)
            s.stateMachine = this;
    }

    void Start()
    {
        ChangeState(nameof(MoveInRangeState));
    }

    // Update is called once per frame
    void Update()
    {
        if (GetComponentInChildren<Health>().currentHealth > 0)
            isAlive = true;
        else
            isAlive = false;
        LOS = gameObject.GetComponent<FOV>().targetsInSight;
        inHealRange = gameObject.GetComponent<HealRange>().targetsInSight;

        
    }
}
