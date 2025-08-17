/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_print_str.c                                     :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: rhanitra <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/04/02 11:33:00 by rhanitra          #+#    #+#             */
/*   Updated: 2024/04/02 11:34:26 by rhanitra         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "ft_printf.h"
#include "limits.h"

int	ft_print_str(char *input)
{
	int	i;
	int	j;

	i = 0;
	j = 0;
	if (!input)
		return (write(1, "(null)", 6));
	while (input[i] != '\0')
	{
		j += write(1, &input[i], 1);
		i++;
	}
	return (j);
}
