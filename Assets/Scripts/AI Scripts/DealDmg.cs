using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DealDmg : MonoBehaviour
{
    public float hitRadius;
    public LayerMask targetMask;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        Physics.OverlapSphere(transform.position, hitRadius, targetMask);
    }
}
