using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "NewUpgrade", menuName = "Upgrades/JumpBoost")]
public class JumpBoostUpgrade : Upgrade
{
    public float boostValue = 0;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    public override void PickUp()
    {
        Debug.Log("SuperJump");
        if(GameObject.FindWithTag("Player").GetComponent<Movement>()!=null)
        {
            
            GameObject.FindWithTag("Player").GetComponent<Movement>().jumpForce *= boostValue;
        }
    }

    public override void Drop()
    {
        Debug.Log("SuperJump");
        if(GameObject.FindWithTag("Player").GetComponent<Movement>()!=null)
        {
            
            GameObject.FindWithTag("Player").GetComponent<Movement>().jumpForce /= boostValue;
        }
    }

    public override void Passive()
    {
        if(Input.GetKeyDown(KeyCode.J))
        {
            if(GameObject.FindWithTag("Player").GetComponent<Movement>()!=null)
            {
                
                GameObject.FindWithTag("Player").GetComponent<Movement>().jumpForce *= boostValue;
            }
        }
    }
}
