using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WheatlyTestScript : MonoBehaviour
{

    public Animator anim;

    public ParticleSystem particleR;
    public ParticleSystem particleL;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetKeyDown(KeyCode.Mouse0)) 
        {
            Debug.Log("HIT!");
            anim.Play("WheatlyDamaged");
        }
        else if (Input.GetKeyDown(KeyCode.Mouse1))
        {
            Debug.Log("HIT!");
            anim.Play("WheatlyShoot");
        }
        else
        {
            Invoke("Invoker", 5f);
        }

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
