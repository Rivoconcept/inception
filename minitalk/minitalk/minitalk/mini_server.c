/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   mini_server.c                                      :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: rhanitra <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/05/29 14:37:53 by rhanitra          #+#    #+#             */
/*   Updated: 2024/07/13 14:06:24 by rhanitra         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "minitalk.h"

char	binary_to_char(const char *bin)
{
	int				i;
	unsigned char	c;

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

void	put_message(unsigned char c, int size)
{
	static int		j = 0;
	static char		*str = NULL;

	if (str == NULL)
	{
		str = (char *)malloc(sizeof(char) * (size + 1));
		if (str == NULL)
			exit(EXIT_FAILURE);
		size = 0;
	}
	str[j] = c;
	j++;
	if (c == '\0')
	{
		str[j] = '\0';
		ft_printf("%s", str);
		free(str);
		str = NULL;
		j = 0;
	}
}

void	message_len(unsigned char c, int *size)
{
	static int			trigger = -1;
	static int			i = 0;
	static char			len[50] = {0};

	len[i] = c;
	i++;
	if (c == '\a')
	{
		len[i] = '\0';
		*size = atoi(len);
		i = 0;
		ft_memset(len, 0, sizeof(len));
		trigger = 1;
	}
	if (trigger == 1)
		put_message(c, *size);
	if (c == '\0')
	{
		*size = 0;
		trigger = -1;
		write(1, "\n", 1);
	}
}

void	handle_signal(int sig)
{
	static int				size = 0;
	unsigned char			c;
	static char				bin[9] = {0};
	static unsigned int		bit_position = 0;

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
			c = binary_to_char(bin);
			message_len(c, &size);
			bit_position = 0;
			ft_memset(bin, 0, 8);
		}
	}
}

int	main(void)
{
	pid_t	server_pid;

	server_pid = getpid();
	ft_printf("mon PID est : %d\n", server_pid);
	while (1)
	{
		signal(SIGUSR1, handle_signal);
		signal(SIGUSR2, handle_signal);
	}
	return (0);
}
