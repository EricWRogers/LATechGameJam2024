using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class JumpBoostUpgrade : MonoBehaviour
{
    public float boostValue;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if(GameObject.FindWithTag("Player").GetComponent<Movement>()!=null)
        {
            GameObject.FindWithTag("Player").GetComponent<Movement>().moveSpeed *= boostValue;
        }
    }
}
