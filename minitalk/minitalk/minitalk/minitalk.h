/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   minitalk.h                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: rhanitra <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/07/13 13:55:48 by rhanitra          #+#    #+#             */
/*   Updated: 2024/07/13 14:00:32 by rhanitra         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef MINITALK_H
# define MINITALK_H

# include <stdio.h>
# include <stdlib.h>
# include <unistd.h>
# include <sys/types.h>
# include <sys/wait.h>
# include <signal.h>
# include <fcntl.h>
# include <string.h>
# include "../ft_printf/ft_printf.h"
# include "../libft/libft.h"

int		nbrlen(int nbr);
char	binary_to_char(const char *bin);
void	put_message(unsigned char c, int size);
void	message_len(unsigned char c, int *size);
void	handle_signal(int sig);
void	send_char(pid_t server_pid, unsigned char octet);
void	send_str(const char *str, int server_pid);

#endif
