using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WinMenu : MonoBehaviour
{
    public bool isPlayerDead = false;

    public GameObject winSection;

    public GameObject healthBar;
    public GameObject PowerUpSection;
    public GameObject TMSection;
    public GameObject GunSection;

    void Start()
    {
        winSection.SetActive(false);
    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetKeyDown(KeyCode.P))
        {
            if(isPlayerDead)
            {
                Win();
            }
        }   
    }

    public void Win()
    {
        Debug.Log("You have WON!");
        Cursor.lockState = CursorLockMode.None;
        Cursor.visible = true;
        winSection.SetActive(true);
        healthBar.SetActive(false);
        GunSection.SetActive(false);
        PowerUpSection.SetActive(false);
        TMSection.SetActive(false);
        Time.timeScale = 1.0f;
    }

    public void Retry()
    {
        //SceneManager.LoadSceneAysnc(1);
    }

    public void LoadMenu()
    {
        Debug.Log("Loading Main Menu");
        Time.timeScale = 1.0f;
        //SceneManager.LoadScene(0);
    }

    public void QuitGame()
    {
        Debug.Log("Quit the Game");
        #if(Unity_Editior)
        EditorApplication.ExitPlayMode();
        #endif
        Application.Quit();
    }
}
