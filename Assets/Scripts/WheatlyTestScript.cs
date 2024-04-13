using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using SuperPupSystems.Helper;

public class WheatlyTestScript : MonoBehaviour
{

    public Animator anim;

    public ParticleSystem particleR;
    public ParticleSystem particleL;

    public GameObject target;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
       /* if(Input.GetKeyDown(KeyCode.Mouse0)) 
        {
            Debug.Log("HIT!");
            anim.Play("WheatlyDamaged");
        }
        else if (Input.GetKeyDown(KeyCode.Mouse1))
        {
            Debug.Log("HIT!");
            anim.Play("WheatlyShoot");
        }
        else if (Input.GetKeyDown(KeyCode.Space))
        {
            Debug.Log("HIT!");
            anim.Play("WheatlyPunch");
        }
        else if (Input.GetKeyDown(KeyCode.Tab))
        {
            Debug.Log("HIT!");
            anim.Play("WheatlyDab");
        }
        else
        {
            Invoke("Invoker", 5f);
        }*/

        if(Input.GetKeyDown(KeyCode.LeftShift))
        {
            gameObject.GetComponent<Health>().Damage(10);
        }
    }

    public void Hurt()
    {
        Debug.Log("HIT!");
        anim.Play("WheatlyDamaged");
    }

    void Ivoker()
    {
        anim.Play("WheatlyMove");
    }

    public void RightShoot()
    {
        particleR.Play();
    }

    public void LeftShoot()
    {
        particleL.Play();
    }
}
