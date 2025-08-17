/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: rhanitra <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/05/29 14:37:53 by rhanitra          #+#    #+#             */
/*   Updated: 2024/05/29 14:37:59 by rhanitra         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <signal.h>
#include <fcntl.h>
#include <string.h>
#include "server.h"

char binary_to_char(const char *bin)
{
    int i;
    unsigned char c;

    i = 0;
    c = 0;
    while (i < 8)
    {
        if (bin[i] == '1')
            c |= 1 << (7 - i);
        i++;
    }
    return (c);
}

/*void operation(unsigned char c)
{
    static int i = 0;
    static char str[1024] = {0};

    str[i] = c;
    i++;
    if (c == '\0')
    {
        str[i] = '\0';
        printf("%s\n", str);
        i = 0;
        memset(str, 0, sizeof(str));                
    }
}*/

void message_len(unsigned char c, int *size)
{
    static int i = 0;
    static char len[50] = {0};

    len[i] = c;
    i++;
    if (c == '\a')
    {
        len[i] = '\0';
        *size = ft_atoi(len);
        i = 0;
        memset(len, 0, sizeof(len));                
    }
}

void put_message(unsigned char c, int *size)
{
    static int j = 0;
    static char *str = NULL;

    if (str == NULL)
    {
        str = (char *)malloc(sizeof(char) * (*size + 1));
        if (str == NULL)
        {
            ft_printf("Erreur d'allocation de mémoire\n");
            exit(EXIT_FAILURE);
        }
    }
    str[j] = c;
    j++;
    if (c == '\0')
    {
        str[*size] = '\0';
        printf("%s\n", str);
        free(str);
        str = NULL;
        *size = 0;
        j = 0;               
    }
}

void handle_signal(int sig)
{
    static int size = 0;
    unsigned char c;
    static char bin[9] = {0};
    static volatile sig_atomic_t bit_position = 0;

    c = 0;
    if (sig == SIGUSR1 || sig == SIGUSR2)
    {
        if (sig == SIGUSR1)
            bin[bit_position] = '1';
        else if (sig == SIGUSR2)
            bin[bit_position] = '0';
        bit_position++;
        if (bit_position == 8)
        {
            bin[8] = '\0';
            c =  binary_to_char(bin);
            message_len(c, &size);
            put_message(c, &size);
            /*str[i] = c;
            i++;
            if (c == '\0')
            {
                str[i] = '\0';
                printf("%s\n", str);
                i = 0;
                memset(str, 0, sizeof(str));                
            }*/
            bit_position = 0;
            memset(bin, 0, 8);
        }
    }
}

int main()
{
    pid_t server_pid;

    server_pid = getpid();
    ft_printf("mon PID est : %d\n", server_pid);
    signal(SIGUSR1, handle_signal);
    signal(SIGUSR2, handle_signal);
    while (1)
    {
        pause();
    }
    return (0);
}

/*int main()
{
    pid_t server_pid = getpid();
    printf("mon PID est : %d\n", server_pid);

    struct sigaction sa;
    sa.sa_handler = handle_signal;
    sa.sa_flags = SA_RESTART;
    sigemptyset(&sa.sa_mask);

    if (sigaction(SIGUSR1, &sa, NULL) == -1 || sigaction(SIGUSR2, &sa, NULL) == -1 || sigaction(SIGTERM, &sa, NULL) == -1)
    {
        perror("sigaction");
        exit(EXIT_FAILURE);
    }

    while (1)
    {
        pause(); // Attendre la réception d'un signal
    }

    return 0;
}*/