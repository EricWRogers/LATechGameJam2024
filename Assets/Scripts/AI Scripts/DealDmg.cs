using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DealDmg : MonoBehaviour
{
    public float hitRadius = 3;
    public LayerMask targetMask;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        Collider[] targetsInHitRadius = Physics.OverlapSphere(transform.position, hitRadius, targetMask);
        for (int i = 0; i < targetsInHitRadius.Length; i++)
        {
            Transform target = targetsInHitRadius[i].transform;
        }
    }
}
