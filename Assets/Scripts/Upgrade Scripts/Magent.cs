using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Magent : MonoBehaviour
{
    public Transform target;
    public float speed = 4.0f;
    
   

    // Start is called before the first frame update
    void Start()
    {
        target = GameObject.FindGameObjectWithTag("Player").transform;
    }

    // Update is called once per frame
    void Update()
    {
        transform.position += (target.position - transform.position) * Time.deltaTime * speed;

      
    }
}
