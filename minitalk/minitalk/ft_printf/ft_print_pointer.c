/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_print_pointer.c                                 :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: rhanitra <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/04/02 11:08:14 by rhanitra          #+#    #+#             */
/*   Updated: 2024/04/06 17:18:23 by rhanitra         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "ft_printf.h"
#include "limits.h"

char	*ft_putnbr_pointer(char const *base, unsigned long input, int base_type)
{
	int		i;
	int		value;
	char	*str;

	i = 0;
	value = 0;
	str = (char *)malloc((sizeof(char) * ft_nbrlen(input)) + 1);
	if (!str)
		ft_strdup("");
	if (input == 0)
	{
		free(str);
		return ("0");
	}
	while (input > 0)
	{
		value = input % base_type;
		str[i] = base[value];
		input /= base_type;
		i++;
	}
	str[i] = '\0';
	return (str);
}

int	ft_print_pointer(unsigned long input, const char *base, int base_type)
{
	int		i;
	int		j;
	char	*str;

	j = 0;
	str = ft_putnbr_pointer(base, input, base_type);
	if (!str || !input)
		return (write(1, "(nil)", 5));
	i = ft_strlen(str) - 1;
	j += write(1, "0x", 2);
	while (i >= 0)
	{
		j += write(1, &str[i], 1);
		i--;
	}
	if (input != 0)
		free(str);
	return (j);
}
