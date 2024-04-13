using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Gun : MonoBehaviour
{
    public GameObject _bullet;
    public AudioSource soundPlayer;
    public PauseMenu pausedGame;
    // Start is called before the first frame update
    void Start()
    {
        UnityEngine.Rendering.DebugManager.instance.enableRuntimeUI = false;

        if (pausedGame == null)
        {
            pausedGame = new PauseMenu();
        }
    }

    // Update is called once per frame
    void Update()
    {
        if(pausedGame != null && pausedGame.isGamePaused == false)
        {
            if (Input.GetKeyDown(KeyCode.Mouse0))
            {
                FireGun();
            }
        }
    }

    void FireGun()
    {
        if (!pausedGame.isGamePaused)
        {
            Instantiate(_bullet, transform.position, transform.rotation);
            soundPlayer.Play();
        }
    }
}
