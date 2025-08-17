/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   mini_client.c                                      :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: rhanitra <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/05/29 14:37:53 by rhanitra          #+#    #+#             */
/*   Updated: 2024/07/13 14:16:25 by rhanitra         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "minitalk.h"

int	nbrlen(int nbr)
{
	int		i;

	i = 0;
	if (nbr <= 0)
		i++;
	while (nbr)
	{
		nbr /= 10;
		i++;
	}
	return (i);
}

void	send_char(pid_t server_pid, unsigned char octet)
{
	int				i;
	unsigned char	bit;

	i = 8;
	bit = 0;
	while (i--)
	{
		bit = octet >> i & 1;
		if (bit)
		{
			kill(server_pid, SIGUSR1);
		}
		else
		{
			kill(server_pid, SIGUSR2);
		}
		usleep(42);
	}
}

void	send_str(const char *str, int server_pid)
{
	int		i;

	i = 0;
	while (str[i] != '\0')
	{
		send_char(server_pid, str[i]);
		i++;
		usleep(50);
	}
}

int	main(int argc, char **argv)
{
	int		server_pid;
	int		size;
	char	*argvlen;

	size = 0;
	if (argc != 3 || (argc == 3 && (!argv[1][0] || !argv[2][0])))
	{
		ft_printf("Veuillez vérifier le nombre d'arguments,\
			il devrait y en avoir 3\n");
		exit(EXIT_FAILURE);
	}
	server_pid = ft_atoi(argv[1]);
	size = ft_strlen(argv[2]);
	argvlen = ft_itoa(size);
	send_str(argvlen, server_pid);
	send_char(server_pid, '\a');
	free(argvlen);
	usleep(100);
	send_str(argv[2], server_pid);
	send_char(server_pid, '\0');
	return (0);
}
