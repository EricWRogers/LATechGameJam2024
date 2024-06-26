using SuperPupSystems.Helper;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HealRange : MonoBehaviour
{
    public float viewRadius;
    [Range(0, 360)]
    public float viewAngle;

    public LayerMask targetMask;
    public LayerMask obstacleMask;
    //[HideInInspector]
    public List<GameObject> visibleTargets = new List<GameObject>();
    [HideInInspector]
    public bool targetsInSight;

    void Update()
    {
        FindVisibleTargets();
    }

    public void FindVisibleTargets()
    {
        visibleTargets.Clear();
        Collider[] targetsInViewRadius = Physics.OverlapSphere(transform.position, viewRadius, targetMask);

        for (int i = 0; i < targetsInViewRadius.Length; i++)
        {
            GameObject target = targetsInViewRadius[i].gameObject;
            Vector3 dirToTarget = (target.transform.position - transform.position).normalized;
            if (Vector3.Angle(transform.forward, dirToTarget) < viewAngle / 2)
            {
                float dstToTarget = Vector3.Distance(transform.position, target.transform.position);
                if (!Physics.Raycast(transform.position, dirToTarget, dstToTarget, obstacleMask))
                {
                    if (target.GetComponent<Health>() != null)
                    {
                        int diff = targetsInViewRadius[i].GetComponentInChildren<Health>().maxHealth - targetsInViewRadius[i].GetComponentInChildren<Health>().currentHealth;
                                  
                        if (diff != 0 && diff != targetsInViewRadius[i].GetComponentInChildren<Health>().maxHealth)
                        {
                            visibleTargets.Add(target);
                        }
                    }
                }
            }
        }

        if (visibleTargets.Count > 0)
        {
            targetsInSight = true;
        }
        else
        {
            targetsInSight = false;
        }
    }
    public Vector3 DirFromAngle(float angleInDegrees, bool angleIsGlobal)
    {
        if (!angleIsGlobal)
        {
            angleInDegrees += transform.eulerAngles.y;
        }
        return new Vector3(Mathf.Sin(angleInDegrees * Mathf.Deg2Rad), 0, Mathf.Cos(angleInDegrees * Mathf.Deg2Rad));
    }
}
