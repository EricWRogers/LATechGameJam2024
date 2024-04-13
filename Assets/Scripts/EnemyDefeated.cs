using UnityEngine;
using UnityEngine.AI;
using SuperPupSystems.Helper;

public class EnemyDefeated : MonoBehaviour
{
    public float delay = 10f;
    private Rigidbody rigi;
    private Animator anim;
    private ParticleSystem particle;
    private Light light;
    public NavMeshAgent agent;

    public ParticleSystem particleExplode;
    public ParticleSystem spareParticle;

    bool shrink;

    private void Start()
    {
        light = GetComponentInChildren<Light>();
        particle = GetComponentInChildren<ParticleSystem>();
        anim = GetComponentInChildren<Animator>();
        rigi = GetComponent<Rigidbody>();
        
        //agent.GetComponentInParent<NavMeshAgent>();
    }
    public void Defeated()
    {
        particleExplode.Play();
        if (spareParticle != null)
        {
            spareParticle.enableEmission = false;
        }
        agent.enabled = false;
        
        
        

        light.enabled = false;
        anim.enabled = false;
        particle.enableEmission = false;

        rigi.isKinematic = false;

        Invoke("Dissolve", delay);
    }

    private void Dissolve()
    {
        Debug.Log("Scaling down");

        shrink = true;
    }

    private void Update()
    {
        if (shrink)
        {
            Vector3 newScale = gameObject.transform.localScale;
            newScale -= Vector3.one * Time.deltaTime;
            gameObject.transform.localScale = newScale;

            if (gameObject.transform.localScale.x <= 0 &&
            gameObject.transform.localScale.y <= 0 &&
            gameObject.transform.localScale.z <= 0)
            {
                //Debug.Log("Dead");
                Destroy(gameObject);
            }

        }
    }
}
