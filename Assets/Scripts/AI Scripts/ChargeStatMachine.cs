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
    public float radius;
    public int dmg;
    Health health;
    public bool isAlive;
    Rigidbody rb;

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
        if (GetComponentInChildren<Health>().currentHealth > 0)
            isAlive = true;
        else
            isAlive = false;
        LOS = gameObject.GetComponent<FOV>().targetsInSight;

    }
    public void Explode()
    {
        Collider[] colliders = Physics.OverlapSphere(transform.position, radius);

        foreach (Collider hit in colliders)
        {
            Debug.Log("BOOM");
            //hit.GetComponent<Health>()?.Damage(dmg);
            if (hit.transform.parent)
            {
                hit.transform.parent.GetComponentInChildren<Health>()?.Damage(dmg);
                //hit.transform.parent.GetComponentInChildren<Rigidbody>()?.isKinematic;
                //hit.transform.parent.GetComponentInChildren<Rigidbody>()?.AddExplosionForce(power, ((ChargeStatMachine)stateMachine).target.position, radius, 0);
            }
            else
            {
                hit.GetComponentInChildren<Health>()?.Damage(dmg);
                //hit.transform.GetComponentInChildren<Rigidbody>()?.AddExplosionForce(power, ((ChargeStatMachine)stateMachine).target.position, radius, 0);
            }

        }
    }

}
