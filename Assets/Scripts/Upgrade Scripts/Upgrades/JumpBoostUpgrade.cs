using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "NewUpgrade", menuName = "Upgrades/Movement/JumpBoost")]
public class JumpBoostUpgrade : Upgrade
{
    public float boostValue = 0;
    public float jumpSpeed = 0;

    public GameObject player;
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
            player = GameObject.FindWithTag("Player");
            
            player.GetComponent<Movement>().jumpForce += boostValue;
        }
    }

    public override void Drop()
    {
        Debug.Log("SuperJump");
        if(player.GetComponent<Movement>()!=null)
        {
            
            GameObject.FindWithTag("Player").GetComponent<Movement>().jumpForce /= boostValue;
        }
    }

    public override void Passive()
    {
        if(Input.GetKeyDown(KeyCode.J))
        {
            if(player.GetComponent<Movement>()!=null)
            {
                
                player.GetComponent<Movement>().jumpForce += boostValue;
            }
        }
    }

    public override void Active()
    {
        if(player.GetComponent<Movement>()!=null)
        {
            
            if(player.GetComponent<Movement>().isGrounded == false)
            {   
                Debug.Log("SetJumpSpeed");
                player.GetComponent<Movement>().moveSpeed *= jumpSpeed;
            }
            
            //player.GetComponent<Movement>().moveSpeed = tempSpeed;
        }
    }
}
